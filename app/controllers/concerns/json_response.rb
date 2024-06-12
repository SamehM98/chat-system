module JsonResponse
  extend ActiveSupport::Concern

  private

  def json_response_success(object, status = :ok)
    render json: object.as_json(except: [:id, :application_id, :chat_id]), status: status
  end

  def json_response_error(message, status)
    render json: { error: message }, status: status
  end
end
