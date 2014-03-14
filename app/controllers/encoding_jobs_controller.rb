class EncodingJobsController < PlugitController
  before_filter :require_login, only: [ :index, :show, :status, :play ]
  before_filter :require_write_access, only: [ :new, :create, :destroy, :reference_presets, :unreference_prests ]
  
  def index
    @encoding_jobs = EncodingJob.owned(logged_in_user)
    @referenced_encoding_jobs = EncodingJob.referenced_for_dashboard
  end
  
  def show
    @encoding_job = EncodingJob.find(params[:id])
  end
  
  def new
    @encoding_job = EncodingJob.new
  end
  
  def create
    @encoding_job = EncodingJob.new(user_params)
    @encoding_job.user_id = logged_in_user_id
    if @encoding_job.save
      flash[:notice] = 'Created new encoding job'
      redirect_to encoding_jobs_path
    else
      flash[:warn] = "Unable to save encoding job. #{@encoding_job.errors.messages}"
      render :new
    end
  end
  
  def destroy
    @encoding_job = EncodingJob.find(params[:id])
    if @encoding_job.owned_by?(logged_in_user) && !@encoding_job.is_reference? && @encoding_job.destroy
      flash[:notice] = 'Encoding job removed'
    else
      flash[:warn] = "Unable to remove encoding job."
    end  
    redirect_to encoding_jobs_path
  end
  
  def status
    response.headers["EbuIo-PlugIt-NoTemplate"] = ''
    @encoding_job = EncodingJob.find(params[:id])
    render layout: false
  end
  
  def play
    @encoding_job = EncodingJob.find(params[:id])
    render layout: 'player'
  end
  
  def reference_presets
    @encoding_job = EncodingJob.find(params[:id])
    set_reference_presets(@encoding_job, true)
    redirect_to play_encoding_job_path(@encoding_job)
  end
  
  def unreference_presets
    @encoding_job = EncodingJob.find(params[:id])
    set_reference_presets(@encoding_job, false)
    redirect_to play_encoding_job_path(@encoding_job)
  end
  
  def reference
    @encoding_job = EncodingJob.find(params[:id])
    @encoding_job.update_attribute(:is_reference, true)
    redirect_to play_encoding_job_path(@encoding_job)
  end
  
  def unreference
    @encoding_job = EncodingJob.find(params[:id])
    @encoding_job.update_attribute(:is_reference, false)
    redirect_to play_encoding_job_path(@encoding_job)
  end
  
  private
  
  def set_reference_presets(job, value)
    job.post_processing_template.update_attribute(:is_reference, value) if job.post_processing_template
    job.variant_jobs.each do |v|
      v.encoder_preset_template.update_attribute(:is_reference, value) if v.encoder_preset_template
    end
  end
  
  def user_params
    params.require(:encoding_job).permit(
      :description,
      :post_processing_template_id,
      :post_processing_flags,
      :user_id,
      variant_jobs_attributes: [ :encoder_preset_template_id, :encoder_flags, :source_file_id ])
  end
end
