class MigrateMessageTagsToTags < ActiveRecord::Migration[8.1]
  def up
    Message.find_each do |message|
      message.tags.each do |tag_name|
        next if tag_name.blank?

        tag = Tag.find_or_create_by!(name: tag_name)

        MessageTag.find_or_create_by!(
          message_id: message.id,
          tag_id: tag.id
        )
      end
    end
  end

  def down
  end
end