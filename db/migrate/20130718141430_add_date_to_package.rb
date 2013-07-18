class AddDateToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :date, :date
  end
end
