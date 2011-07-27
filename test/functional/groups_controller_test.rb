require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get join" do
    get :join
    assert_response :success
  end

end
