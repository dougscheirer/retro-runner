class RemoveColumnFromOutstandings < ActiveRecord::Migration
  def change
    remove_column :outstandings, :assigned_to
  end
end
