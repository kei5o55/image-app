class CreateMessageTags < ActiveRecord::Migration[8.1]
  def change
    create_table :message_tags do |t|
      t.references :message, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :message_tags,
              [:message_id, :tag_id],
              unique: true
  end
end