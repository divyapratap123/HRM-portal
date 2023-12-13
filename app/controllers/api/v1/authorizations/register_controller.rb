module Api::V1
  module Authorizations
		class RegisterController < ApplicationController
			  include JsonWebToken
			  include Response

			  protect_from_forgery with: :exception, except: :create
			  skip_before_action :authorize_request, only: :create

			 def create
        begin    	
          ActiveRecord::Base.transaction do
            params[:user][:role] = params[:user][:role]
            @user = User.new(user_params)
            if @user.save
            	render json: {messages: "user created succesfully"}
            else
              error_model(400, @user.errors.full_messages.join(','))
              raise ActiveRecord::Rollback
            end
          end
        rescue Exception => e
          email_exist = e&.message.include?("email has already") rescue nil
          if email_exist
            un_expected_error("#{I18n.t 'email_exist'}",400)
          else
            un_expected_error("#{I18n.t 'unexpected_registation'}",302)
          end
        end
      end
      private 
      def user_params
        params.require(:user).permit(:email, :password, :name,:role)
      end
		end
  end
end