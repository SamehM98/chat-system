class MessageCreatorJob
  include Sidekiq::Job

  def perform(application_token, chat_number, message_number, body)
    chat = Chat.lock.find_by_token_and_number(application_token, chat_number)

    if chat.present?
      ActiveRecord::Base.transaction do
        Message.create(chat: chat, message_number: message_number, body: body)
      end
      else
        MessageCreatorJob.perform_in(30.seconds, application_token, chat_number, message_number, body)
    end
  end
end
