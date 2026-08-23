module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_channel

      # GET /api/v1/channels/:channel_id/messages
      def index
        messages = @channel.messages
          .with_attached_image
          .includes(:tags)
          .order(created_at: :asc)

        formatted_messages = messages.map do |message|
          message.to_formatted_json.merge(
            url: message.image.attached? ? url_for(message.image) : nil
          )
        end

        render json: formatted_messages, status: :ok
      end

      # POST /api/v1/channels/:channel_id/messages
      def create
        # 一連の作成・配信処理は Service に丸投げ
        result = MessageCreationService.call(
          channel: @channel,
          params: message_params,
          image_url_generator: ->(image) { url_for(image) }
        )

        if result.success?
          render json: result.formatted_data, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_channel
        @channel = Channel.find(params[:channel_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Channel not found" }, status: :not_found
      end

      def message_params
        params.permit(:content, :type, :image, tags: [])
      end
    end
  end
end