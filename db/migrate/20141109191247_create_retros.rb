class CreateRetros < ActiveRecord::Migration
  def change
    create_table :retros do |t|
      t.integer :project_id
      t.datetime :meeting_date
      t.string :status
      t.timestamps
    end
  end
end
