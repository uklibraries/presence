class ChangeLanguageInPackages < ActiveRecord::Migration
  def change
    remove_column :packages, :language
    add_column :packages, :language_id, :integer
    add_index :packages, :language_id
  end
end
