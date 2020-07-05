class AddLastSeenToUserConversation < ActiveRecord::Migration[5.2]
  def change
    add_column :user_conversations, :last_seen, :datetime
  end
end
