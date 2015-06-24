class AddRetroIdToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :retro_id, :integer
  end
end
