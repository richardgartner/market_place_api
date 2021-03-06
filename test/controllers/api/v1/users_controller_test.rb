require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
  end

  test "should show user" do
    get api_v1_user_url(@user), as: :json
    assert_response :success
    # Test returned json user email matches user email
    json_response = JSON.parse(self.response.body)
    assert_equal @user.email, json_response['email']
  end

  test 'should create user' do
    assert_difference('User.count') do
      post api_v1_users_url, params: { user: { email: 'jimbob@test.com', password: 'password'}}, as: :json
    end

    assert_response :created
  end

  test 'should not create user with taken email' do
    post api_v1_users_url, params: { user: { email: @user.email, password: 'password'}}, as: :json
    assert_response :unprocessable_entity
  end

  test 'should update user' do
    put api_v1_user_url(@user), params: { user: {email: @user.email, password: 'newpassword'}}, as: :json
    assert_response :success
  end

  test 'should not update user with invalid params' do
    put api_v1_user_url(@user), params: { user: {email: 'bad_email_address', password: 'newpassword'}}, as: :json
    assert_response :unprocessable_entity
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user), as: :json
    end

    assert_response :no_content
  end

end
