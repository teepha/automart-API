class SetDefaultForCarStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :cars, :status, :string, default: "Available"
  end
end
