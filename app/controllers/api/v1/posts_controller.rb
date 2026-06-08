class Api::V1::PostsController < ApplicationController
  include Rails.application.routes.url_helpers

  def index
    posts =Post.all

    render json: posts.map { |p|
      {
        id: p.id,
        title: p.title,
        description: p.description,
        image_url: p.image.attached? ? url_for(p.image):nil
      }
    }
  end
end
