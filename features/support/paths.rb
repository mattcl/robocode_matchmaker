module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /the home\s?page/
      '/'
    when /login page/
      new_user_session_path
    when /register/
      new_user_registration_path
    when /robots page/
      bots_path
    else
      begin
        page_name =~/the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        rails "Can't find mapping from \"#{page_name}\" to a path.\n"
      end
    end
  end
end

World(NavigationHelpers)
