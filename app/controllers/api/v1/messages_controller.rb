module Api
  module V1
    class MessagesController < ApplicationController
      include JsonResponse

      before_action :set_chat, only: %i[index show]
      before_action :set_message, only: %i[show]

      def index
          json_response_success(@chat.messages)
      end

      def show
          if(@message)
            json_response_success(@message)
          else
            json_response_error('Message not found', :not_found)
          end
      end

      def create
        message_number = Messages::MessageCreator.call(params[:application_token],params[:chat_number].to_i,message_params[:body])
        json_response_success({ number:message_number,  body: message_params[:body] }, :created)
      end


      def update
        MessageUpdaterJob.perform_async(params[:application_token], params[:chat_number].to_i, params[:number].to_i, message_params[:body])
        json_response_success(number:params[:number], body: message_params[:body])
      end


    private

      def set_chat
        @chat = Chat.find_by_token_and_number(params[:application_token], params[:chat_number])
      end

      def set_message
        @message = @chat.messages.find_by(message_number: params[:number])
      end

      def message_params
        params.require(:message).permit(:body)
      end

    end



  end
end

