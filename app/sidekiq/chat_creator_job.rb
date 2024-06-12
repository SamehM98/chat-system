class ChatCreatorJob
  include Sidekiq::Job


  def perform(application_token, number,app_key)
    ActiveRecord::Base.transaction do
      application = Application.find_by(token: application_token)
      if application.present?
        Chat.create(application: application, chat_number: number)
      end
    end
  end



end
