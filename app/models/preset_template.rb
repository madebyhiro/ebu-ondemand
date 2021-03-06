class PresetTemplate < ActiveRecord::Base
  include Referencable
  include Owned
  
  enum preset_type: [ :encoder_preset, :post_processing_preset ]
  
  serialize :tags, Array
  
  HUMAN_READABLE_PRESET_TYPES = [ 'Encoder preset (ffmpeg)', 'Post-processing preset (MP4Box)' ].freeze
  
  has_many :variant_jobs, foreign_key: 'encoder_preset_template_id', dependent: :nullify
  has_many :encoding_jobs, foreign_key: 'post_processing_template_id', dependent: :nullify
  
  validates :preset_type, presence: true
  validates :template_text, presence: true
  validates :description, presence: true
end
