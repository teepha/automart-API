class DropBodyTypeTable < ActiveRecord::Migration[6.0]
  def up
    remove_column :cars, :body_type_id
    drop_table :body_type
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
