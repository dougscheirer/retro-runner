class ChangeStatusToEnum < ActiveRecord::Migration
  def change
    rename_column :retros, :status, :status_string
    add_column :retros, :status, :integer
    Retro.find_each { |retro|
      old_status = retro.status_string.downcase
      if (old_status == 'new') then
        retro.status = 'not_started'
      else
        retro.status = old_status
      end
      retro.save
    }
    remove_column :retros, :status_string
  end
end
