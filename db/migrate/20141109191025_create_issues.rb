class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :retrospective_id
      t.string :type
      t.string :member
      t.string :description

      t.timestamps
    end
  end
end
