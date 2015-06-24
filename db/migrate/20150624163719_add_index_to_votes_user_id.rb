class AddIndexToVotesUserId < ActiveRecord::Migration
  def change
    add_index :votes, :member_id
  end
end
