require 'test_helper'

class CommentControllerTest < ActionController::TestCase
  test "should get content:text" do
    get :content:text
    assert_response :success
  end

  test "should get commentable_id:integer" do
    get :commentable_id:integer
    assert_response :success
  end

  test "should get commentable_type:string" do
    get :commentable_type:string
    assert_response :success
  end

end
