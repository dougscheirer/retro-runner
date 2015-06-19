module IssuesHelper
  def project_name
    Project.find(Retro.find(params[:id][:project_id]))
  end

  def is_owner?
    @current_user.id == @retro.creator_id
  end

  def status_to_int
    Retro.statuses[@retro.status]
  end

  def next_status
    Retro.statuses.find { |k,v| Integer(v) == status_to_int + 1 }[0]
  end

  def status_title
    ['Start Retro','Review Issues','Complete Review','Close Voting','Finish Retro'][status_to_int]
  end
end
