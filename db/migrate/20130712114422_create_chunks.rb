class CreateChunks < ActiveRecord::Migration
  def change
    create_table :chunks do |t|
      t.string :chunk
      t.references :user
      t.references :asset

      t.timestamps
    end
    add_index :chunks, :user_id
    add_index :chunks, :asset_id
  end
end
