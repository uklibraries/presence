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
  after_commit :index_record
  before_destroy :remove_from_index

  def ensure_identifier
    if self.identifier.nil? or self.identifier.strip == ''
      MintWorker.perform_async(self.id)
    end
  end

  def to_solr
    the_date = self.date ? self.date.iso8601 : '0000-00-00'
    h = {
      'id' => self.identifier,
      'who_s' => self.creator,
      'what_s' => self.title,
      'when_dt' => "#{the_date}T00:00:00Z",
      'access_t' => self.access.name,
      'retention_t' => self.retention.name,
      'username_s' => User.find(self.user_id).username,
      'title_display' => self.title,
      'pub_date' => the_date[0..3],
    }
    if self.retention == Retention.temporal
      h['retention_dt'] = "#{self.retention_date}T00:00:00Z"
    end
    h
  end

  def index_record
    Blacklight.solr.add(self.to_solr)
    Blacklight.solr.commit
  end

  def remove_from_index
    Blacklight.solr.delete_by_id(self.identifier)
    Blacklight.solr.commit
  end
end
