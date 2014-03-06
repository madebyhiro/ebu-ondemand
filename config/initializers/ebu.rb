module EBU
  # Limit upload size for individual file uploads.
  UPLOAD_MAX_SIZE = 256.megabytes
  
  # Timeout setting for communicating with transcoders (in seconds).
  TRANSCODER_TIMEOUT = 5
  
  # Base location for intermediate files generated by ffmpeg / Codem.
  INTERMEDIATE_FILE_LOCATION = [Rails.root, 'tmp', 'intermediate'].join(File::SEPARATOR)
  
  # Final location for DASHed files
  FINAL_FILE_LOCATION = [Rails.root, 'public', 'dash'].join(File::SEPARATOR)
  
  # Callback URL for Codem transcoder. Depends on Rails environment and setup.
  CALLBACK_URL_FOR_CODEM = case Rails.env
    when 'development' then 'http://localhost:3000/codem_notifications'
    when 'development_remote' then 'http://localhost:3000/codem_notifications'
    else raise "Codem callback URL not yet configured."
  end
  
  # Callback URL for http-runner jobs. Depends on Rails environment and setup.
  CALLBACK_URL_FOR_HTTP_RUNNER = case Rails.env
    when 'development' then 'http://localhost:3000/http_runner_notifications'
    when 'development_remote' then 'http://localhost:3000/http_runner_notifications'
    else raise "http-runner callback URL not yet configured."
  end
  
  # http-runner host. Depends on Rails environment and setup.
  HTTP_RUNNER_HOST = case Rails.env
    when 'development' then 'http://localhost:9000'
    when 'development_remote' then 'http://localhost:9000'
    else raise "http-runner host not yet configured."
  end
  
  CONFORMANCE_ANT_BUILD_FILE = [Rails.root, 'vendor', 'conformance', 'MPDValidator', 'build.xml'].join(File::SEPARATOR)
  #ALLOWED_CONTENT_TYPES = /\Aimage|\Avideo|\Atext/
end