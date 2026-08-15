require "test_helper"

class ImageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get image_index_url
    assert_response :success
  end
end
