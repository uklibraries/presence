class AddFileToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :file, :string
  end
end
