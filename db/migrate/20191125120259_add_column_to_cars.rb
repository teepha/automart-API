class AddColumnToCars < ActiveRecord::Migration[6.0]
  def change
    add_column :cars, :body_type_id, :integer
  end
end
