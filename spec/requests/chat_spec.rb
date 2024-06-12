require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.describe 'Chats', type: :request do
  application = FactoryBot.create(:application)

  describe 'index' do
    let(:chats) { create_list(:chat, 2, application:) }

    it 'Returns all chats' do
      get api_v1_application_chats_path application_token: application.token
      json = JSON.parse(response.body)
      expect(json.count).to eq application.chats.count
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'show' do
    chat = FactoryBot.create(:chat, application:)

    it 'Should returns the requested chat with status code :ok' do
      get api_v1_application_chat_path application_token: application.token, number: chat.chat_number
      json = JSON.parse(response.body)
      expect(json['chat_number']).to eq(chat.chat_number)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'create' do
    let(:creation_service_double) { instance_double(Chats::ChatCreator) }
    before do
      allow(creation_service_double).to receive(:call).and_return(1)
      allow(Chats::ChatCreator).to receive(:new).with(application.token).and_return(creation_service_double)
      post api_v1_application_chats_path application_token: application.token
    end

    it 'Create successfully' do
      expect(response).to have_http_status(:created)
    end
  end

end
