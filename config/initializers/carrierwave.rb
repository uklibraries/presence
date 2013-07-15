CarrierWave.configure do |config|
  config.permissions = 0664
  config.directory_permissions = 0775
  # config.storage = :fog
  config.storage = :file
  config.root = Rails.root
  #config.fog_credentials = {
  #  :provider => 'local',
  #  :local_root => Rails.root,
  #}
  #config.fog_directory = ''
  #config.fog_attributes = {
  #  :multipart_chunk_size => 20000000,
  #}
end
