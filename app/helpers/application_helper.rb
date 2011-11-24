# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def javascript_include_action controller, action
    folder = "#{RAILS_ROOT}/public/javascripts"
    controller_path = "#{folder}/application/#{controller}.js"
    action_path = "#{folder}/application/#{controller}/#{action}.js"
    output = ""
    if File.exist?(controller_path)
      output << javascript_include_tag("application/#{controller}")
    end
    if File.exist?(action_path)
      output << javascript_include_tag("application/#{controller}/#{action}")
    end
    output
  end
  
end
