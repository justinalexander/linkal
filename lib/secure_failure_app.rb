class SecureFailureApp < Devise::FailureApp

  # Use full URL instead of path for authentication failure redirect
  def redirect_url
    if skip_format?
      send(:"new_#{scope}_session_url")
    else
      send(:"new_#{scope}_session_url", :format => request_format)
    end
  end

end

