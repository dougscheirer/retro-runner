class AddIndexToVotesIssueId < ActiveRecord::Migration
  def change
    add_index :votes, :issue_id
  end
end
