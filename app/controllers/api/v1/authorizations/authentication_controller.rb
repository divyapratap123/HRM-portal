module Api::V1
  module Authorizations
    class AuthenticationController < ApplicationController
      skip_before_action :authorize_request, only: :login
      protect_from_forgery with: :exception, except: :login

      def login
        @user = User.find_by_email(params[:user][:email])
        if @user&.authenticate(params[:user][:password])
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.now + 24.hours.to_i
          render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                         username: @user.username }, status: :ok
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end

