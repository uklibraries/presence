class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.references :user
      t.string :who
      t.string :what
      t.integer :when
      t.string :where
      t.string :contributor
      t.string :coverage
      t.string :creator
      t.string :description
      t.string :format
      t.string :identifier
      t.string :language
      t.string :publisher
      t.string :relation
      t.string :rights
      t.string :source
      t.string :title
      t.string :type
      t.string :access
      t.string :retention
      t.string :status

      t.timestamps
    end
    add_index :packages, :user_id
  end
end
