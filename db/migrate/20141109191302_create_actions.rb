class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :new

      t.timestamps
    end
  end
end
