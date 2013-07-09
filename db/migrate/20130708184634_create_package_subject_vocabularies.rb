class CreatePackageSubjectVocabularies < ActiveRecord::Migration
  def change
    create_table :package_subject_vocabularies do |t|
      t.belongs_to :package
      t.belongs_to :subject

      t.timestamps
    end
    add_index :package_subject_vocabularies, :package_id
    add_index :package_subject_vocabularies, :subject_id
  end
end
