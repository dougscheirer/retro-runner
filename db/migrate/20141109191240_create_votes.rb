class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :issue_id
      t.integer :member_id
      t.timestamps
    end
  end
end
