module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_channel

      # GET /api/v1/channels/:channel_id/messages
      def index
        # Active Storage の N+1 問題を防ぐため with_attached_image を使用
        messages = @channel.messages.with_attached_image.order(created_at: :asc)

        render json: messages.map { |msg| format_message(msg) }, status: :ok
      end

      # POST /api/v1/channels/:channel_id/messages
      def create
        user = User.first || User.create!(name: "Test User", email: "test@example.com")

        message = @channel.messages.build(
          content: message_params[:content],
          message_type: message_params[:type] || "text",
          tags: message_params[:tags] || [],
          user: user
        )

        if message_params[:image].present?
          message.image.attach(message_params[:image])
        end

        if message.save
          formatted_data = format_message(message)

          # ⚡️ 接続中の全クライアントへ即時ブロードキャスト
          MessagesChannel.broadcast_to(@channel, formatted_data)

          # 送信元へのレスポンス
          render json: formatted_data, status: :created
        else
          render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_channel
        @channel = Channel.find(params[:channel_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Channel not found" }, status: :not_found
      end

      # Strong Parameters の設定
      def message_params
        # FormData の場合、JSONのネスト（params.require(:message)）ではなく
        # トップレベルに値が入るため params.permit で受け取ります
        params.permit(:content, :type, :image, tags: [])
      end

      # TypeScript の MessageItem 型に合致する形式にレスポンスを整える
      def format_message(msg)
        {
          id: msg.id,
          channelId: msg.channel_id,
          type: msg.image.attached? ? "image" : msg.message_type,
          content: msg.content,
          # Active Storage に画像が添付されていればその完全な URL を生成
          url: msg.image.attached? ? url_for(msg.image) : nil,
          time: msg.created_at.strftime("%H:%M"),
          tags: msg.tags || [],
          isEdited: msg.is_edited || false
        }
      end
    end
  end
end