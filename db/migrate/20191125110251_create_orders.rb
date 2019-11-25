class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :car, null: false, foreign_key: true
      t.float :amount
      t.string :status

      t.timestamps
    end
  end
end
