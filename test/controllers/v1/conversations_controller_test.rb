require 'test_helper'

class V1::ConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # make 2 users
    @user1 = User.create(username: 'Mrmannner', first_name: 'Mrthemanmatt', last_name: 'Themamnner', password: 'Password123', password_confirmation: 'Password123', email: 'myman@example.com')
    @user2 = User.create(username: 'Myfriendman', first_name: 'brofriend', last_name: 'frienderr', password: 'Password1234', password_confirmation: 'Password1234', email: 'myfriend@example.com')
    @user3 = User.create(username: 'Anothergoodfriend', first_name: 'goodfriend', last_name: 'frienderrr', password: 'Password12345', password_confirmation: 'Password12345', email: 'otherfriend@example.com')
    @access_token = JWT.encode({ user_id: @user1.id }, ENV['JWT_SECRET'], 'HS256')
  end

  test "Find conversation by user" do
    get "/v1/conversations/find?with=#{@user2.id}", headers: { 'Authorization': "Bearer #{@access_token}" }

    assert_response :success
    assert_equal(1, Conversation.count)

    get "/v1/conversations/find?with=#{@user2.id}", headers: { 'Authorization': "Bearer #{@access_token}" }
    assert_response :success
    assert_equal(1, Conversation.count)

    get "/v1/conversations/find?with=#{@user3.id}", headers: { 'Authorization': "Bearer #{@access_token}" }
    assert_response :success
    assert_equal(2, Conversation.count)
  end

  test "Find conversation" do
    @conversation = Conversation.create(users: [@user1, @user2])

    get v1_conversation_path(@conversation), headers: { 'Authorization': "Bearer #{@access_token}" }
    assert_response :success

    # user 3 cannot find this conversation
    @access_token3 = JWT.encode({ user_id: @user3.id }, ENV['JWT_SECRET'], 'HS256')

    get v1_conversation_path(@conversation), headers: { 'Authorization': "Bearer #{@access_token3}" }
    assert_response :not_found
  end
end
