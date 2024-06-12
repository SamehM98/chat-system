module Chats
  class ChatCreator < ApplicationService

  def initialize(application_token)
    @application_token = application_token
  end


    def call
      application_key = ApplicationHelpers.generate_key(@application_token)
      get_chat_number(application_key) # get the current chat count for the application, increment it, and return it
      store_chat_key_in_memory # create a redis key value pair with 0 for the new chat
      ChatCreatorJob.perform_async( @application_token,@chat_number,application_key)
      @chat_number #return chat number
    end

    private

  def get_chat_number(application_key)
    @chat_number = InMemoryManager.increment(application_key)
  end


  def store_chat_key_in_memory
    chat_key = ChatHelpers.generate_key(@application_token, @chat_number)
    InMemoryManager.set(chat_key,0)
  end

  end
end
