class AddColumnToOutstandings < ActiveRecord::Migration
  def change
    add_column :outstandings, :creator_id, :integer
  end
end
