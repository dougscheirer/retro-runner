json.array!(@issues) do |issue|
  json.extract! issue, :id, :retro_id, :issue_type, :member, :description
  json.url issue_url(issue, format: :json)
end
