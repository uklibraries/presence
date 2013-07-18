class RemoveAccessFromPackages < ActiveRecord::Migration
  def change
    remove_column :packages, :access
  end
end
