class Asset < ActiveRecord::Base
  belongs_to :user
  belongs_to :package
  has_many :chunks, dependent: :destroy
  attr_accessible :name, :file, :size
end
