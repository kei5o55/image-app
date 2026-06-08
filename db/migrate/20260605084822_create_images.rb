class CreateImages < ActiveRecord::Migration[8.1]
  def change
    create_table :images do |t|
      t.text :title
      t.text :description
      t.integer :likes

      t.timestamps
    end
  end
end
