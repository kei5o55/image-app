class Message < ApplicationRecord
  belongs_to :channel
  belongs_to :user, optional: true # ユーザー認証導入前は optional にしておくとテストしやすいです

  # message_type は "text" か "image" のみ許可
  validates :message_type, inclusion: { in: %w[text image] }

  # tags が nil の場合は空配列を入れる
  before_validation :set_default_tags

  private

  def set_default_tags
    self.tags ||= []
  end
end