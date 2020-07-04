require 'test_helper'

class V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username: 'Mattieman', first_name: 'Matthew', email: 'matt@example.com', last_name: 'Portland', password: 'Password123', password_confirmation: 'Password123')
  end

  test "Login" do
    new_login = {
      email: 'matt@example.com',
      password: 'Password123'
    }

    post v1_sessions_path, params: { session: new_login }
    assert_response :success
    parsed_response = JSON.parse(response.body)
    user_id_from_token = JWT.decode(parsed_response['token'], ENV['JWT_SECRET'], 'HS256').first['user_id']
    assert_equal(@user.id, user_id_from_token)
  end

  test "Invalid email" do
    invalid_login = {
      email: 'verybademail',
      password: 'Password123'
    }

    post v1_sessions_path, params: { session: invalid_login }
    assert_response :bad_request
    parsed_response = JSON.parse(response.body)
    assert_match(/Please enter a valid email/, parsed_response['error'])
  end

  test "Invalid password" do
    invalid_password = {
      email: 'matt@example.com',
      password: 'notmypassword'
    }
    post v1_sessions_path, params: { session: invalid_password }
    assert_response :bad_request
    parsed_response = JSON.parse(response.body)
    assert_match(/Email and password did not match/, parsed_response['error'])
  end

  test "Email that is not in db" do
    foreign_email = {
      email: 'thisonedoesntexist@example.com',
      password: 'mysecretpassword'
    }
    post v1_sessions_path, params: { session: foreign_email }
    assert_response :not_found
    parsed_response = JSON.parse(response.body)
    assert_match(/User with email thisonedoesntexist@example.com not found. Please sign up/, parsed_response['error'])
  end
end
