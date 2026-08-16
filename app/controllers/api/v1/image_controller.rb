module Api
  module V1
    class ImageController < ApplicationController
      # GET /api/v1/image/search
      def search
        result = ImageSearchService.call(
          tags: params[:tags],
          quantity: params[:quantity]
        )

        images = messages.map do |message|
          {
            url: url_for(message.image)
          }
        end

        render json: {
          images: images
        }
      end
    end
  end
end