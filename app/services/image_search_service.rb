class ImageSearchService
  def initialize(tag, quantity)
    @tag = tag
    @quantity = quantity.to_i
  end

  def call
    messages = Message.where(#条件に一致するMessageを取得
      "tags @> ?",
      [@tag].to_json
    )

    messages = messages.select do |message|
        # 画像が添付されているメッセージだけ残す
        message.image.attached?
    end

    messages.sample(@quantity)#ランダムにquantity数選んだメッセージを残す（これをリターンしとるで）
  end
end