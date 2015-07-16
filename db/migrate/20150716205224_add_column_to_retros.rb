class AddColumnToRetros < ActiveRecord::Migration
  def change
    add_column :retros, :good_icon, :integer
    add_column :retros, :meh_icon, :integer
    add_column :retros, :bad_icon, :integer
  end
end
