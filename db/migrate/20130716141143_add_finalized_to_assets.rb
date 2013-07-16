class AddFinalizedToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :finalized, :boolean, :default => false
  end
end
