class CreateBodyTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :body_types do |t|
      t.string :title

      t.timestamps
    end
  end
end
