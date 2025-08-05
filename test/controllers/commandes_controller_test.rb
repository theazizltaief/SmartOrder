require "test_helper"

class CommandesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get commandes_create_url
    assert_response :success
  end

  test "should get show" do
    get commandes_show_url
    assert_response :success
  end
end
