module Api
  module V1

    class ChatsController < ApplicationController
      include JsonResponse

      before_action :set_application, only: [:index]

      def index
          json_response_success(@application.chats)
      end

      def create
        chat_number = Chats::ChatCreator.call(params[:application_token])
        json_response_success({ chat_number: }, :created)
      end

      def show
        chat = Chat.find_by_token_and_number(params[:application_token],params[:number])

          if(chat)
            json_response_success(chat)
          else
            json_response_error('Chat not found', :not_found)
          end
      end


      def search_messages
        app_token = params[:application_token]
        chat_number = params[:chat_number]

        chat_key = ChatHelpers.generate_key(app_token, chat_number)

        search_result = Message.search(params[:query], chat_key)


        if search_result
          json_response_success(search_result)
        else
          json_response_error('Message not found', :not_found)
        end
      end


      private

      def set_application
        @application = Application.find_by(token: params[:application_token])
        if (!@application)
          json_response_error('Application not found', :not_found)
        end
      end
    end
  end
end
