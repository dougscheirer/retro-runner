class ChangeVoteIdName < ActiveRecord::Migration
  def change
    rename_column :votes, :member_id, :user_id
  end
end
