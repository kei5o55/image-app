# 既存のデータをクリア（リレーションの末端から順に削除）
puts "Cleaning up old data..."
Attachment.destroy_all
Message.destroy_all
Channel.destroy_all
User.destroy_all
Post.destroy_all
Image.destroy_all

puts "Creating seed data..."

# 1. ユーザー（Users）の作成
users = User.create!([
  { name: "Alice", email: "alice@example.com" },
  { name: "Bob",   email: "bob@example.com" },
  { name: "Charlie", email: "charlie@example.com" }
])
puts "Created #{users.count} users."

# 2. チャンネル（Channels）の作成
channels = Channel.create!([
  { name: "general" },
  { name: "random" },
  { name: "dev-talk" }
])
puts "Created #{channels.count} channels."

general_channel = channels.find { |c| c.name == "general" }
dev_channel     = channels.find { |c| c.name == "dev-talk" }
alice           = users.find { |u| u.name == "Alice" }
bob             = users.find { |u| u.name == "Bob" }

# 3. メッセージ（Messages）の作成
msg1 = Message.create!(
  channel: general_channel,
  user: alice,
  content: "こんにちは！開通テスト用の最初のメッセージです。"
)

msg2 = Message.create!(
  channel: general_channel,
  user: bob,
  content: "RailsとNext.jsの連携確認用のメッセージです！添付ファイルも確認してみます。"
)

msg3 = Message.create!(
  channel: dev_channel,
  user: alice,
  content: "Docker Composeでの環境構築、順調ですね。"
)
puts "Created 3 messages."

# 4. 添付ファイル（Attachments）の作成 (schema.rb の path, file_name カラムに対応)
Attachment.create!([
  {
    message: msg2,
    file_name: "sample-screenshot.png",
    path: "https://via.placeholder.com/600x400.png?text=Sample+Image"
  },
  {
    message: msg2,
    file_name: "test-document.pdf",
    path: "/uploads/test-document.pdf"
  }
])
puts "Created 2 attachments."

# 5. その他のテーブル（Posts / Images）のダミーデータ作成
Post.create!([
  { title: "Rails 8.1 起動テスト", description: "Docker上のRails APIが正常動作しています。" }
])

Image.create!([
  { title: "テスト画像1", description: "初期表示確認用", likes: 5 }
])

puts "Seed data creation completed successfully!"