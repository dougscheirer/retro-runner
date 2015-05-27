module IssuesHelper
  def project_name
    Project.find(Retro.find(params[:id][:project_id]))
  end
end
