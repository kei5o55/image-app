class MessageCreationService
  Result = Struct.new(
    :success,
    :message,
    :formatted_data,
    :errors,
    keyword_init: true
  ) do
    def success?
      success
    end
  end

  def self.call(channel:, params:, image_url_generator:)
    new(
      channel: channel,
      params: params,
      image_url_generator: image_url_generator
    ).call
  end

  def initialize(channel:, params:, image_url_generator:)
    @channel = channel
    @params = params
    @image_url_generator = image_url_generator
  end

  def call
    user = User.first || User.create!(
      name: "Test User",
      email: "test@example.com"
    )

    message = nil

    ActiveRecord::Base.transaction do
      # 1. メッセージ作成
      message = @channel.messages.create!(
        content: @params[:content],
        message_type: @params[:type] || "text",
        user: user
      )

      # 2. タグを関連付け
      tag_names = @params[:tags] || []

      tag_names.each do |tag_name|
        next if tag_name.blank?

        tag = Tag.find_or_create_by!(name: tag_name)
        message.tags << tag
      end

      # 3. 画像をアタッチ
      if @params[:image].present?
        message.image.attach(@params[:image])
      end
    end

    # 4. DB保存成功後にブロードキャスト
    formatted_data = message.to_formatted_json.merge(
      url: message.image.attached? ? @image_url_generator.call(message.image) : nil
    )

    MessagesChannel.broadcast_to(@channel, formatted_data)

    Result.new(
      success: true,
      message: message,
      formatted_data: formatted_data
    )

  rescue ActiveRecord::RecordInvalid => e
    Result.new(
      success: false,
      errors: e.record.errors.full_messages
    )
  end
end