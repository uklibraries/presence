class AddAssembledToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :assembled, :boolean, :default => false
  end
end
