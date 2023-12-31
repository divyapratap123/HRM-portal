class ApplicationController < ActionController::Base
  include JsonWebToken
  before_action :authorize_request

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['token']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
