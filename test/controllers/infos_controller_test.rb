require 'test_helper'

class InfosControllerTest < ActionDispatch::IntegrationTest
  test "should get about_us" do
    get infos_about_us_url
    assert_response :success
  end

  test "should get terms" do
    get infos_terms_url
    assert_response :success
  end

end
