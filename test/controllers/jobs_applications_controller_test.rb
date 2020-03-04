require 'test_helper'

class JobsApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jobs_application = jobs_applications(:one)
  end

  test "should get index" do
    get jobs_applications_url
    assert_response :success
  end

  test "should get new" do
    get new_jobs_application_url
    assert_response :success
  end

  test "should create jobs_application" do
    assert_difference('JobsApplication.count') do
      post jobs_applications_url, params: { jobs_application: { addresslat: @jobs_application.addresslat, addresslong: @jobs_application.addresslong, age: @jobs_application.age, email: @jobs_application.email, expiry: @jobs_application.expiry, nationality: @jobs_application.nationality, phone: @jobs_application.phone } }
    end

    assert_redirected_to jobs_application_url(JobsApplication.last)
  end

  test "should show jobs_application" do
    get jobs_application_url(@jobs_application)
    assert_response :success
  end

  test "should get edit" do
    get edit_jobs_application_url(@jobs_application)
    assert_response :success
  end

  test "should update jobs_application" do
    patch jobs_application_url(@jobs_application), params: { jobs_application: { addresslat: @jobs_application.addresslat, addresslong: @jobs_application.addresslong, age: @jobs_application.age, email: @jobs_application.email, expiry: @jobs_application.expiry, nationality: @jobs_application.nationality, phone: @jobs_application.phone } }
    assert_redirected_to jobs_application_url(@jobs_application)
  end

  test "should destroy jobs_application" do
    assert_difference('JobsApplication.count', -1) do
      delete jobs_application_url(@jobs_application)
    end

    assert_redirected_to jobs_applications_url
  end
end
