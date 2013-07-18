class AddAccessToPackages < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :packages, :access_id, :integer
    add_index :packages, :access_id
  end
end
