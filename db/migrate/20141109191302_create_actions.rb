class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :description
      t.integer :retro_id
      t.integer :issue_id
      t.string :assigned_to
      t.timestamps
    end
  end
end
