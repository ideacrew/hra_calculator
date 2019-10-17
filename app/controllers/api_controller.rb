class ApiController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? || request.format.xml? || request.format.js? }

  before_action :authorize_session

  def authorize_session
    header = request.headers['Authorization']
    if header.blank?
      head :unauthorized
      return
    end
    auth_token = header.split(' ').last
    unless HraClientSession.valid_session?(auth_token)
      head :unauthorized
      return
    end
  end
end