module IssuesHelper
  def project_name
    Project.find(Retro.find(params[:id][:project_id]))
  end

  def is_owner?
    @current_user.id == @retro.creator_id
  end
end
