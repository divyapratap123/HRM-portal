module Api::V1
  module Authorizations
   class PasswordsController < ApplicationController
   	include JsonWebToken
   	before_action :authorize_request, only: [:change_password]
   	protect_from_forgery with: :exception, except: :login

   	  def change_password
        if params[:password].present? && !current_user.valid_password?(params[:password])
          error_model(400, "#{I18n.t 'wrong_password'}")
          return
        end

        if current_user.reset_password!(params[:new_password])
          user = current_user
          user.update(password_updated: true)
          success_model(200, "#{I18n.t 'password_change_success'}")
        else
          error_model(400, current_user.errors.full_messages.join(','))
          return
        end
      end
   end
 end
end
