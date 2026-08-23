class Message < ApplicationRecord
  belongs_to :channel
  belongs_to :user, optional: true

  has_many :message_tags, dependent: :destroy
  has_many :tags, through: :message_tags

  has_one_attached :image

  validates :message_type, inclusion: { in: %w[text image] }

  before_validation :set_default_tags

  # フロントエンド（TypeScript）向けのJSON構造に変換するメソッド
  def to_formatted_json
    {
      id: id,
      channelId: channel_id,
      type: message_type,
      content: content,
      url: image.attached? ? Rails.application.routes.url_helpers.rails_blob_path(image) : nil,
      time: created_at.iso8601,
      tags: tags.pluck(:name),
      isEdited: is_edited
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

  def has_image? #画像を持っているか調べる
    attachments.any? { |attachment| attachment.image? }
  end

  
end