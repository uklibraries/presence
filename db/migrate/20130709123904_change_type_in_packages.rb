class ChangeTypeInPackages < ActiveRecord::Migration
  def change
    remove_column :packages, :type
    add_column :packages, :type_id, :integer
    add_index :packages, :type_id
  end
end
