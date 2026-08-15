class ImageController < ApplicationController
  def index
  images = ImageSearchService.call(
    tags: params[:tags],
    quantity: params[:quantity]
  )

  render json: images
end
end
