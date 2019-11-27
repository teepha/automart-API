class AddBodyTypeToCars < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE body_type AS ENUM ('car', 'truck', 'trailer', 'van', 'bus', 'minibus');
    SQL

    add_column :cars, :body_type, :body_type, index: true
  end

  def down
    remove_column :cars, :body_type

    execute <<-SQL
      DROP TYPE body_type;
    SQL
  end
end
