class AddRetentionDateToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :retention_date, :date, :default => '0000-00-00'
  end
end
