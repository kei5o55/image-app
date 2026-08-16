class Drops < ActiveRecord::Migration[8.1]
  def change
    drop_table :posts
    drop_table :attachments
    drop_table :images
  end
end
