module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_channel

      # GET /api/v1/channels/:channel_id/messages
      def index
        messages = @channel.messages.order(created_at: :asc)

        # MessageItem 型にフォーマットして出力
        render json: messages.map { |msg| format_message(msg) }, status: :ok
      end

      # POST /api/v1/channels/:channel_id/messages
      def create
        # テスト用の暫定ユーザー（認証機能実装後は current_user 等に変更）
        user = User.first || User.create!(name: "Test User", email: "test@example.com")

        message = @channel.messages.build(message_params)
        message.user = user

        if message.save
          render json: format_message(message), status: :created
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

      def message_params
        # フロントから受け取ったパラメータを Rails のカラム名にマッピング
        p = params.require(:message).permit(:content, :type, :url, :isEdited, tags: [])
        
        {
          content: p[:content],
          message_type: p[:type] || "text",
          url: p[:url],
          is_edited: p[:isEdited] || false,
          tags: p[:tags] || []
        }
      end

      # TypeScript の MessageItem インターフェースに完全に合致するハッシュを返す関数
      def format_message(msg)
        {
          id: msg.id,
          channelId: msg.channel_id,
          type: msg.message_type,
          content: msg.content,
          url: msg.url,
          time: msg.created_at.strftime("%H:%M"), # 例: "18:30" (必要に応じて ISO8601等に変更可能)
          tags: msg.tags || [],
          isEdited: msg.is_edited
        }
      end
    end
  end
end