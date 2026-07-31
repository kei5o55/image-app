class Message < ApplicationRecord
  belongs_to :channel
  belongs_to :user, optional: true

  # Active Storage の画像アタッチメント定義
  has_one_attached :image

  # message_type は "text" か "image" のみ許可
  validates :message_type, inclusion: { in: %w[text image] }

  # tags が nil の場合は空配列を入れる
  before_validation :set_default_tags

  # 画像の完全な URL を返すヘルパーメソッド
  def image_url
    return nil unless image.attached?

    # include Rails.application.routes.url_helpers を追加するか、
    # コントローラー側等で host のコンテキストを持って呼ぶのが安全です
    Rails.application.routes.url_helpers.url_for(image)
  end

  private

  def set_default_tags
    self.tags ||= []
  end
end