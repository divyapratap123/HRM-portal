require 'httpclient'
module Api::V1
  module Authorizations
   class SocialsLoginController < ApplicationController
   	skip_before_action :authorize_request, only: :create
   	protect_from_forgery with: :exception, except: :create
   	DATA_URL = "https://www.googleapis.com/oauth2/v3/userinfo"
      
      def create
         @access_token = params[:access_token]
         @client = HTTPClient.new
         response = @client.get(DATA_URL, access_token: @access_token)
         @data = JSON.parse(response.body).with_indifferent_access
         if @data.present?
         	@user = User.find_by(email: @data[:email], uid: @data[:sub], provider: 'Google')

         	@user = User.create(name: @data[:name], email: @data[:email], access_token: params[:access_token], uid: @data[:sub], password: 'Password@123', provider: 'Google') if !@user.present?
         	if @user.valid?
         	 	token = JsonWebToken.encode(user_id: @user.id)
         	 	time = Time.now + 24.hours.to_i
                render json: {name: @user.name ,email: @user.email, token: token, exp: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
            else
            	render json: {message: 'Invalid User credential'}
         	 end
         else 
         	render json: {message: 'Invalid access token'}
         end
      end
   end
  end
end
