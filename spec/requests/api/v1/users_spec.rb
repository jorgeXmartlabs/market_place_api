require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:serializer) { Api::V1::UserBlueprint }
  let!(:user) { create :user }
  let(:user_id) { user.id }

  describe 'GET /users/:id' do
    before { get api_v1_user_path(user_id) }

    context 'when there is an user with that specific id' do
      it 'returns status code 200' do
        expect(response).to have_http_status :ok
      end

      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end
    end

    context 'when the user does not exits' do
      let(:user_id) { 1000 }

      it 'returns not found' do
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'POST /users' do
    let(:valid_attributes) { { email: 'valid@email.com', password: 'pw1234' } }

    subject { post '/api/v1/users', params: valid_attributes }

    context 'when the user can be successfully created' do
      before(:each) { subject }

      it 'returns status code 201' do
        expect(response).to have_http_status :created
      end

      it 'returns the created user' do
        expect(json['email']).to eq('valid@email.com')
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/users', params: { email: 'invalid' } }

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'PUT /users/:id' do
    let(:valid_attributes) { { email: 'update@email.com' } }

    context 'when the user exists' do
      before { put "/api/v1/users/#{user_id}", params: valid_attributes }

      it 'updates the user' do
        expect(json).not_to be_empty
        expect(json['email']).to eq('update@email.com')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /users/:id' do
    before { delete "/api/v1/users/#{user_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
