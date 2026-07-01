class Message < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  has_many :attachments, dependent: :destroy
end
