class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :new

      t.timestamps
    end
  end
end
