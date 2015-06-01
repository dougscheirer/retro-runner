class AddCreatorToRetros < ActiveRecord::Migration
  def change
    add_column :retros, :creator_id, :integer
  end
end
