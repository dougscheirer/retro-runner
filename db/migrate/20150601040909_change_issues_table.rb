class ChangeIssuesTable < ActiveRecord::Migration
  def change
    remove_column :issues, :member
    add_column :issues, :creator_id, :integer
  end
end
