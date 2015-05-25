json.array!(@retros) do |retro|
  json.extract! retro, :id, :meeting_date, :project_id, :status
  json.url retro_url(retro, format: :json)
end
