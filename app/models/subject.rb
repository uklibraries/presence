class Subject < ActiveRecord::Base
  belongs_to :user
  has_many :package_subject_vocabularies
  has_many :packages, through: :package_subject_vocabularies
  attr_accessible :subject
end
