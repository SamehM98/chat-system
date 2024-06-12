module Messages
class MessageCreator < ApplicationService


  def initialize(application_token, chat_number, body)
    @application_token = application_token
    @chat_number = chat_number
    @body = body
  end

  def call
    chat_key = ChatHelpers.generate_key(@application_token, @chat_number)
    message_number = InMemoryManager.increment(chat_key)
    MessageCreatorJob.perform_async(@application_token, @chat_number, message_number, @body)
    message_number
  end

end

end
