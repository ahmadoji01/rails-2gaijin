require 'test_helper'

class CategoryControllerTest < ActionDispatch::IntegrationTest
  test "should get add" do
    get category_add_url
    assert_response :success
  end

end
