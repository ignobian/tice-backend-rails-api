require 'test_helper'

class V1::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  # setup do
  #   # make all plans
  #   FactoryBot.create(:user, blogs: 0)

  #   @user_token = JWT.encode({ user_id: @company.salesreps.first.id },ENV['JWT_AUTH_SECRET'], 'HS256')
  #   @admin_token = JWT.encode({ user_id: @company.admins.first.id },ENV['JWT_AUTH_SECRET'], 'HS256')
  # end

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
end
