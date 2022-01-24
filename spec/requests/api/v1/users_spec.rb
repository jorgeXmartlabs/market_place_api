require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:json_response) { JSON.parse response.body, symbolize_names: true }
  let(:serializer) { Api::V1::UserBlueprint }

  describe 'get an user' do
    let!(:user) { create :user }

    subject { get api_v1_user_path(user_id) }

    context 'when there is an user with that specific id' do
      let(:user_id) { user.id }

      before(:each) { subject }

      it 'returns success' do
        expect(response).to have_http_status :ok
      end

      it 'returns the created user' do
        expect(json_response).to eq serializer.render_as_hash(user)
      end
    end
  end

  describe 'get an invalid user' do
    it 'returns not found' do
      get api_v1_user_path('invalid')
      expect(response).to have_http_status :not_found
    end
  end

  describe 'create an user' do
    subject { post api_v1_users_path, params: { user: params } }

    context 'when the user can be successfully created' do
      let(:params) { attributes_for :user }

      before(:each) { subject }

      it 'returns success' do
        expect(response).to have_http_status :created
      end

      it 'returns the created user' do
        expect(json_response).to eql serializer.render_as_hash(User.first)
      end
    end

    context 'when the user cannot be created' do
      let(:params) { attributes_for :user, email: nil }

      before(:each) { subject }

      it 'returns success' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end
end
