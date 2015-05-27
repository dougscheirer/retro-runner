module RetrosHelper
  def project_name
    project_id = (params[:project_id] unless !params[:project_id])
    project_id ||= Retro.find(params[:retro_id])[:project_id]
    Project.find(project_id)[:name]
  end
end
