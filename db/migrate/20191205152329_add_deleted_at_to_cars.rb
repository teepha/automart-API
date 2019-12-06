class AddDeletedAtToCars < ActiveRecord::Migration[6.0]
  def change
    add_column :cars, :deleted_at, :datetime, precision: 6
  end
end
