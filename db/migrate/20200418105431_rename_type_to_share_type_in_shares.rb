class RenameTypeToShareTypeInShares < ActiveRecord::Migration[5.2]
  def change
    rename_column :shares, :type, :share_type
  end
end
