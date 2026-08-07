class MessageCreationService
  # 結果を返すためのシンプルな構造体を定義
  Result = Struct.new(:success, :message, :formatted_data, :errors, keyword_init: true) do
    def success?
      success
    end
  end

  def self.call(channel:, params:)
    new(channel:, params:).call
  end

  def initialize(channel:, params:)
    @channel = channel
    @params = params
  end

  def call
    # 1. 送信者ユーザーの準備
    user = User.first || User.create!(name: "Test User", email: "test@example.com")

    # 2. メッセージの組み立て
    message = @channel.messages.build(
      content: @params[:content],
      message_type: @params[:type] || "text",
      tags: @params[:tags] || [],
      user: user
    )

    # 3. 画像のアタッチ
    message.image.attach(@params[:image]) if @params[:image].present?

    # 4. 保存とブロードキャスト
    if message.save
      formatted_data = message.to_formatted_json
      MessagesChannel.broadcast_to(@channel, formatted_data)

      Result.new(success: true, message: message, formatted_data: formatted_data)
    else
      Result.new(success: false, errors: message.errors.full_messages)
    end
  end
end