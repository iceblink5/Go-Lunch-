class AddGroupIdToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :group_id, :integer
  end

  def self.down
    remove_column :votes, :group_id
  end
end
