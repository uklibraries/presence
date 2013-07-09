class ChangeFormatInPackages < ActiveRecord::Migration
  def change
    remove_column :packages, :format
    add_column :packages, :format_id, :integer
    add_index :packages, :format_id
  end
end
