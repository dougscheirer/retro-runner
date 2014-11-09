class CreateRetros < ActiveRecord::Migration
  def change
    create_table :retros do |t|
      t.string :new

      t.timestamps
    end
  end
end
