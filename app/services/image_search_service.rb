class ImageSearchService
  def self.call(tags:, quantity:)
    new(tags, quantity).call
  end

  def initialize(tags, quantity)
    @tags = tags
    @quantity = quantity
  end

  def call
    # 画像検索処理
  end
end