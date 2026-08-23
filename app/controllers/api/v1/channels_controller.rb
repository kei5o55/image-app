module Api
  module V1
    class ChannelsController < ApplicationController

      # GET /api/v1/channels
      def index
        channels = Channel.all.order(created_at: :asc)

        render json: channels, status: :ok
      end

      # POST /api/v1/channels
      def create
        channel = Channel.new(channel_params)

        if channel.save
          render json: channel, status: :created
        else
          render json: {
            errors: channel.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def channel_params
        params.permit(:name)
      end

    end
  end
end