module Api
  module V1
    class ChannelsController < ApplicationController
      def index
        channels = Channel.all.order(created_at: :asc)
        render json: channels, status: :ok
      end
    end
  end
end