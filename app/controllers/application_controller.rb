class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do
    if current_user
      respond_to do |format|
        format.html { render file: 'errors/forbidden', status: :forbidden, layout: nil }
        format.all { render nothing: true, status: :forbidden }
      end
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path(ok_url: params[:ok_url]) }
        format.all { render nothing: true, status: :unauthorized }
      end
    end
  end

  def controller_namespace
    controller_name_segments = params[:controller].split('/')
    controller_name_segments.pop
    controller_name_segments.join('/').camelize
  end

  def current_ability
    #@current_ability ||= Ability.new(current_user, controller_namespace)
  end

  def append_info_to_payload(payload)
    super
    payload[:host] = request.host
  end

  def ok_url_or(url)
    params[:ok_url] || url
  end
  helper_method :ok_url_or

  def default_url_options
    { host: Settings.site }
  end
end
