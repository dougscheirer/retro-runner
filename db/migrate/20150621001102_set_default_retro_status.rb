class SetDefaultRetroStatus < ActiveRecord::Migration
  def change
    change_column :retros, :status, :integer, :default => 0
    Retro.find_each { |retro|
      retro.status = 0 if retro.status.nil?
      retro.save!
    }
  end
end
