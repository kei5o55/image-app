class CreateAttachments < ActiveRecord::Migration[8.1]
  def change
    create_table :attachments do |t|
      t.references :message, null: false, foreign_key: true
      t.string :file_name
      t.string :path

      t.timestamps
    end
  end
end
