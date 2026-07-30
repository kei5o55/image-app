module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_channel

      def index
        messages = @channel.messages
                           .includes(:user, :attachments)
                           .order(created_at: :asc)

        render json: messages.as_json(
          include: {
            user: { only: [:id, :name, :email] },
            attachments: { only: [:id, :file_name, :path, :created_at] } # ← カラム名を実体に修正
          }
        ), status: :ok
      end

      def create
        user = User.first || User.create!(name: "Test User", email: "test@example.com")

        message = @channel.messages.build(message_params)
        message.user = user

        if message.save
          render json: message.as_json(
            include: {
              user: { only: [:id, :name, :email] },
              attachments: { only: [:id, :file_name, :path, :created_at] }
            }
          ), status: :created
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
        params.require(:message).permit(:content)
      end
    end
  end
end