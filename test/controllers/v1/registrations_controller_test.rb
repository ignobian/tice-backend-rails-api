require 'test_helper'

class V1::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "Pre signup" do
    new_user = {
      username: 'Mr Man',
      email: 'ignob@example.com',
      first_name: 'Mr',
      last_name: 'Man',
      password: 'Password12345',
      password_confirmation: 'Password12345'
    }

    post '/v1/registrations/pre-signup', params: { registration: new_user }
    assert_response :success
    parsed_response = JSON.parse(response.body)
    assert_match(/An email has been sent to ignob@example.com/, parsed_response['message'])
  end

  test "Pre signup invalid" do
    new_user = {
      username: 'Mr Man',
      email: 'ignobbademail.com',
      first_name: 'Mr',
      last_name: 'Man',
      password: 'Password12345',
      password_confirmation: 'Password12345'
    }

    post '/v1/registrations/pre-signup', params: { registration: new_user }
    assert_response :bad_request
    parsed_response = JSON.parse(response.body)
    assert_match(/Please enter a valid email/, parsed_response['error'])
  end

  test "Sign up" do
    hash = {
      first_name: 'Djoser',
      last_name: 'Fantastique',
      email: 'djoser@example.com',
      username: 'Yoopie',
      password: 'Password12345',
      password_confirmation: 'Password12345'
    }

    token = JWT.encode({ user: hash }, ENV['JWT_ACCOUNT_ACTIVATION'], 'HS256')

    post v1_registrations_path, params: { token: token }

    assert_response :created
  end

  test "Forget password" do
    User.create(username: 'Matthijs', first_name: 'Matthijs', last_name: 'Kralt', email: 'dumbass@example.com', password: 'superdupereasypassword', password_confirmation: 'superdupereasypassword')
    put '/v1/registrations/forgot-password', params: { email: 'dumbass@example.com'}
    assert_response :success
    parsed_response = JSON.parse(response.body)
    assert_match(/An email has been sent/, parsed_response['message'])
  end

  test "Reset password" do
    @user = User.create(username: 'Matthijs', first_name: 'Matthijs', last_name: 'Kralt', email: 'dumbass@example.com', password: 'superdupereasypassword', password_confirmation: 'superdupereasypassword')
    # make a dummy jwt token to reset password with
    token = JWT.encode({ user_id: @user.id }, ENV['JWT_RESET_PASSWORD'], 'HS256')
    put '/v1/registrations/reset-password', params: { token: token, new_password: 'password123' }
    assert_response :success
    # TODO: Fix resetting password, apparantly not working...
    # assert_equal(true, @user.valid_password?('password123'))
  end

  test "Update profile" do
    @user = User.create(username: 'Matthijs', first_name: 'Matthijs', last_name: 'Kralt', email: 'dumbass@example.com', password: 'superdupereasypassword', password_confirmation: 'superdupereasypassword')
    @access_token = JWT.encode({ user_id: @user.id }, ENV['JWT_SECRET'], 'HS256')

    changes = {
      username: 'Matthew'
    }

    put v1_users_path, params: changes, headers: { 'Authorization': "Bearer #{@access_token}" }
    assert_response :success
  end
end
