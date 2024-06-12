require 'rails_helper'

RSpec.describe 'Applications', type: :request do
  describe 'index' do
    applications = FactoryBot.create_list(:application, 2)

    it 'Returns all applications with status code 200' do
      get api_v1_applications_path
      json = JSON.parse(response.body)
      expect(json.count).to eq Application.all.count
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'show' do
    application = FactoryBot.create(:application)

    it 'Gets a single application' do
      get api_v1_application_path application.token
      json = JSON.parse(response.body)
      expect(json['token']).to eq(application.token)
      expect(response).to have_http_status(:ok)
    end

    it 'Returns not found with invalid token' do
      get api_v1_application_path 'sometoken123'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'create' do

    it 'Creates an application' do
      post api_v1_applications_path, params: { application: { name: 'Test' } }
      expect(response).to have_http_status(:created)
    end

    it 'Returns error with invalid params' do
      post api_v1_applications_path, params: { application: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

  end

  describe 'update' do
    application = FactoryBot.create(:application)

    it 'Updates an application' do
      put "#{api_v1_applications_path}/#{application.token}", params: { application: { name: 'New Name' } }
      expect(response).to have_http_status(:ok)
      expect(Application.find(application.id).name).to eq('New Name')
    end

    it 'Returns error with invalid update params'do
      put "#{api_v1_applications_path}/#{application.token}", params: { application: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

end
