class AddDetailsToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :message_type, :string, default: "text", null: false
    add_column :messages, :url, :string
    add_column :messages, :is_edited, :boolean, default: false, null: false
    add_column :messages, :tags, :jsonb, default: [], null: false
  end
end