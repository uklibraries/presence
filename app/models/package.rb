class Package < ActiveRecord::Base
  belongs_to :user
  has_many :package_subject_vocabularies
  has_many :subjects, through: :package_subject_vocabularies
  attr_accessible :access, :contributor, :coverage, :creator, :description, :format, :identifier, :language, :publisher, :relation, :retention, :rights, :source, :status, :title, :type, :what, :when, :where, :who, :subject_ids
end
