class AddVotesCountToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :votes_count, :integer, default: 0
  end
end