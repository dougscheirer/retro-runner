class AddCompleteToOutstandings < ActiveRecord::Migration
  def change
    add_column :outstandings, :complete, :boolean
  end
end
