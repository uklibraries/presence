class Package < ActiveRecord::Base
  belongs_to :user
  belongs_to :access
  belongs_to :format
  belongs_to :retention
  belongs_to :type
  belongs_to :language
  has_many :package_subject_vocabularies
  has_many :subjects, through: :package_subject_vocabularies
  has_many :assets, dependent: :destroy
  attr_accessible :access_id, :contributor, :coverage, :creator, :date, :description, :format_id, :language_id, :publisher, :relation, :retention_date, :retention_id, :rights, :source, :status, :title, :type_id, :what, :when, :where, :who, :subject_ids

  after_save :ensure_identifier

  def ensure_identifier
    if self.identifier.nil? or self.identifier.strip == ''
      MintWorker.perform_async(self.id)
    end
  end
end
