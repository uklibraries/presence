class ChangeDefaultAccessAndRetentionForPackages < ActiveRecord::Migration
  def change
    change_column_default :packages, :access_id, 4
    change_column_default :packages, :retention_id, 1
  end
end
