json.key_format! camelize: :lower

json.array! @conversations do |conversation|
  json.id conversation.id
  json.with do

    conversation_user = conversation.users.where.not(id: @user.id).first

    json.(conversation_user, :id, :username)

    if conversation_user.photo.attached?
      json.photo conversation_user.photo.key
    end
  end
end