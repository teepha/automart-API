class CreateCars < ActiveRecord::Migration[6.0]
  def change
    create_table :cars do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :state
      t.string :status
      t.float :price
      t.string :manufacturer
      t.string :model

      t.timestamps
    end
  end
end
