module Api
  module V1
    class ApplicationsController < ApplicationController

  include JsonResponse

  before_action :set_application, only: [:show, :update]

  def index
    @applications = Application.all
    json_response_success(@applications)
  end

  def show
    if @application
      json_response_success(@application)
    else
      json_response_error('Not found', :not_found)
    end
  end


  def create
    @application = Application.new(application_params)
    if @application.save
      key = ApplicationHelpers.generate_key(@application.token)
      InMemoryManager.set(key,0)
      json_response_success(@application, :created)
    else
      json_response_error('Something went wrong', :unprocessable_entity)
    end
  end

  def update
    if @application.update(application_params)
      json_response_success(@application)
    else
      json_response_error(@application.errors.full_messages.join(', '), :unprocessable_entity)
    end
  end

  private

  def set_application
    @application = Application.find_by(token: params[:token])
  end

  def application_params
    params.require(:application).permit(:name)
  end
end

end
end
