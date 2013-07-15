class Package < ActiveRecord::Base
  belongs_to :user
  belongs_to :format
  belongs_to :type
  belongs_to :language
  has_many :package_subject_vocabularies
  has_many :subjects, through: :package_subject_vocabularies
  has_many :assets, dependent: :destroy
  attr_accessible :access, :contributor, :coverage, :creator, :description, :format_id, :identifier, :language_id, :publisher, :relation, :retention, :rights, :source, :status, :title, :type_id, :what, :when, :where, :who, :subject_ids
end
