module Api
  module V1
    class ImageController < ApplicationController
      def search
        result = ImageSearchService.call(
          tags: params[:tags],
          quantity: params[:quantity]
        )

        render json: result
      end
    end
  end
end