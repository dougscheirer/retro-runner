class CreateRetros < ActiveRecord::Migration
  def change
    create_table :retros do |t|
      t.datetime :meeting_date
      t.integer :project_id
      t.string :status

      t.timestamps
    end
  end
end
