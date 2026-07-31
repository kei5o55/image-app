# 既存メッセージのクリア
Attachment.destroy_all
Message.destroy_all

general_channel = Channel.find_by(name: "general") || Channel.first
user = User.first

Message.create!([
  {
    channel: general_channel,
    user: user,
    content: "テキストメッセージのテストです！",
    message_type: "text",
    tags: ["重要", "テスト"],
    is_edited: false
  },
  {
    channel: general_channel,
    user: user,
    content: "画像メッセージのテストです。",
    message_type: "image",
    url: "https://via.placeholder.com/300",
    tags: ["画像"],
    is_edited: true
  }
])

puts "Updated seed messages for MessageItem type!"