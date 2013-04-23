class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :category_id
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
