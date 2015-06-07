module ApplicationHelper
  def full_title(title)
    "RetroRunner"
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type.to_sym)} fade in flash") do
        concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

  def user(id)
    user = User.find_by_id(id) if !id.nil?
    return user if !user.nil?
    User.new(:name=>"Unknown", :email=>"unknown@example.com", :id=>id)
  end

end