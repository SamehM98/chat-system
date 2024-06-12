class MessageUpdaterJob
  include Sidekiq::Job

  def perform(application_token, chat_number, message_number, body)
    ActiveRecord::Base.transaction do
      chat = Chat.find_by_token_and_number(application_token, chat_number)
      message = chat.messages.find_by(message_number: message_number)

      if chat.present? && message.present?
        message.update(body: body)
      else
        MessageUpdaterJob.perform_in(30.seconds, application_token, chat_number, message_number, body)
      end

    end
  end
end
