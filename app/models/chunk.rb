class Chunk < ActiveRecord::Base
  belongs_to :user
  belongs_to :asset
  attr_accessible :chunk
  mount_uploader :chunk, ChunkUploader
end
