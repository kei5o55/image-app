class RemoveTagsFromMessages < ActiveRecord::Migration[8.1]
  def change
    remove_column :messages, :tags, :jsonb
  end
end
