class PackageSubjectVocabulary < ActiveRecord::Base
  belongs_to :package
  belongs_to :subject
  # attr_accessible :title, :body
end
