require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.describe 'Messages', type: :request do
  application = FactoryBot.create(:application)
  chat = FactoryBot.create(:chat, application:)
  let(:indexed) { double(index: true) }

  before do
    allow_any_instance_of(Message).to receive(:__elasticsearch__).and_return(indexed)
    allow(indexed).to receive(:index_document).and_return(true)
  end

  describe 'index' do
    messages = FactoryBot.create_list(:message, 4, chat:)

    it 'Should return chat messages and status code 200' do
      get api_v1_application_chat_messages_path application_token: application.token, chat_number: chat.chat_number
      json = JSON.parse(response.body)
      expect(json.count).to eq(chat.messages.count)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'show' do
    message = FactoryBot.create(:message, chat:)

    it 'Should show and status code 200' do
    get api_v1_application_chat_message_path application_token: application.token, chat_number: chat.chat_number,
      number: message.message_number

      json = JSON.parse(response.body)
      expect(json['message_number']).to eq(message.message_number)
      expect(response).to have_http_status(:success)

    end
  end


  describe 'create' do
    let(:params) { { message: { body: 'Message body' } } }
    let(:creation_service_double) { instance_double(Messages::MessageCreator) }

    before do
      allow(creation_service_double).to receive(:call).and_return(1)
      allow(Messages::MessageCreator).to receive(:new).with(application.token, chat.chat_number,
                                                            params[:message][:body]).and_return(creation_service_double)

      post api_v1_application_chat_messages_path application_token: application.token, chat_number: chat.chat_number,
                                                 params:
    end

    it 'Should return status code :created' do
      expect(response).to have_http_status(:created)
    end

    it 'Should have called the MessageCreator service' do
      expect(creation_service_double).to have_received(:call)
    end
  end

  describe 'update' do
    message = FactoryBot.create(:message, chat:)
    let(:params) { { message: { body: 'Updated body' } } }
    let(:update_service_double) { instance_double(Messages::MessageRemover) }

      it 'Call message updater job once' do
        expect do
          put api_v1_application_chat_message_path application_token: application.token, chat_number: chat.chat_number,
                                                   number: message.message_number, params:
        end.to change(MessageUpdaterJob.jobs, :size).by(1)
      end

      it 'Should return status code ok' do
        put api_v1_application_chat_message_path(application_token: application.token, chat_number: chat.chat_number,
                                                 number: message.message_number, params:)

        expect(response).to have_http_status(:ok)
      end
    end

end
