class AddReferenceToCars < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :cars, :body_types, column: :body_type_id
  end
end
