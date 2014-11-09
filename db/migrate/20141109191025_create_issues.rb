class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :new

      t.timestamps
    end
  end
end
