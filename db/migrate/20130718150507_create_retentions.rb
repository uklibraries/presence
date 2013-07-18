class CreateRetentions < ActiveRecord::Migration
  def change
    create_table :retentions do |t|
      t.string :name

      t.timestamps
    end

    remove_column :packages, :retention
    add_column :packages, :retention_id, :integer
    add_index :packages, :retention_id
  end
end
