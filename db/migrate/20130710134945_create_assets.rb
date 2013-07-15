class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :name
      t.references :user
      t.references :package

      t.timestamps
    end
    add_index :assets, :user_id
    add_index :assets, :package_id
  end
end
