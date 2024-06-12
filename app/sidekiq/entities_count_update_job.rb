require 'sidekiq-scheduler'

class EntitiesCountUpdateJob
  include Sidekiq::Worker

  def perform
    ActiveRecord::Base.transaction do
      applications = Application.all

      applications.each do |application|
        application_key = ApplicationHelpers.generate_key(application.token)
        application.chats_count = InMemoryManager.get(application_key)
      end
      applications.each(&:save)

      chats = Chat.all

      chats.each do |chat|
        chat_key = ChatHelpers.generate_key(chat.application_token, chat.chat_number)
        chat.messages_count = InMemoryManager.get(chat_key)
      end
      chats.each(&:save)

    end
  end
end
