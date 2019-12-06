class AddDeletedAtToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :deleted_at, :datetime, precision: 6
  end
end
