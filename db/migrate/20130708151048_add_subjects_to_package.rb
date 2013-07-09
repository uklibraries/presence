class AddSubjectsToPackage < ActiveRecord::Migration
  def change
    create_table :packages_subjects do |t|
      t.belongs_to :package
      t.belongs_to :subject
    end
  end
end
