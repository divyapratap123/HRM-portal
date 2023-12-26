class ApidocsController < ActionController::Base
  include Swagger::Blocks
  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Hrm On-Demand HRM Portal App'
      key :description, 'Hrm On-Demand HRM Portal App. The main pillar of the app is a HR, Employye and Manager'
      contact do
        key :name, 'sonu rathor'
      end
    end
    key :host, 'dev-app.hrm.com' if Rails.env.development?
    key :host, 'staging-app.hrm.com' if Rails.env.staging?
    key :host, 'app.hrm.com' if Rails.env.production?

    key :basePath, '/api/v1'
    key :consumes, ['application/x-www-form-urlencoded'] #this means what responce we are going to send
    key :produces, ['application/json'] # and this means what type of responce we are going to get from user
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES_V1 = [
    #SwaggerController, #controller details goes from here where from you are creating api
    Api::V1::Authorizations::AuthenticationController,
    Api::V1::Authorizations::RegisterController,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES_V1)
  end

  def swagger_ui
  end
end
