class CreateOutstandingsUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :outstandings_users, id: false do |t|
      t.integer :outstanding_id
      t.integer :user_id
    end
    add_index(:outstandings_users, [:outstanding_id, :user_id])
  end
end
