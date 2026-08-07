class Message < ApplicationRecord
  belongs_to :channel
  belongs_to :user, optional: true

  has_one_attached :image

  validates :message_type, inclusion: { in: %w[text image] }

  before_validation :set_default_tags

  # フロントエンド（TypeScript）向けのJSON構造に変換するメソッド
  def to_formatted_json
    {
      id: id,
      channelId: channel_id,
      type: display_type,
      content: content,
      url: image_url,
      time: created_at.strftime("%H:%M"),
      tags: tags || [],
      isEdited: is_edited || false
    }
  end

  # 表示用タイプの判定ロジック
  def display_type
    image.attached? ? "image" : message_type
  end

  # 画像URLの生成ロジック
  def image_url
    return nil unless image.attached?

    Rails.application.routes.url_helpers.url_for(image)
  end

  private

  def set_default_tags
    self.tags ||= []
  end
end