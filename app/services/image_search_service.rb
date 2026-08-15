class ImageSearchService
  def initialize(tag, quantity)
    @tag = tag
    @quantity = quantity.to_i
  end

  def call
    messages = Message.where(
      "tags @> ?",
      [@tag].to_json
    )

    messages = messages.select do |message|
      message.image.attached?
    end

    messages.sample(@quantity)
  end
end