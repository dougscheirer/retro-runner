class AddDiscussedToRetros < ActiveRecord::Migration
  def change
    add_column :retros, :discussed_index, :integer
    add_column :retros, :discussed_type, :integer
  end
end
