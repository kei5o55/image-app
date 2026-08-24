module Api
  module V1
    class TagsController < ApplicationController
      def index
        tags = Tag.order(:name)        

        render json: tags, status: :ok
      end
    end
  end
end