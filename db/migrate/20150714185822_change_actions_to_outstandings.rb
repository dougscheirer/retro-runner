class ChangeActionsToOutstandings < ActiveRecord::Migration
  def change
    rename_table :actions, :outstandings
  end
end
