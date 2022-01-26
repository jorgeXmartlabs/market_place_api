require 'rails_helper'
require 'json_web_token'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create :user }
  let(:user_id) { user.id }
  let(:user_email) { user.email }
  let(:encoded_user_id) { JsonWebToken.encode(user_id) }

  describe 'GET #show' do
    before { get :show, params: { id: user_id } }

    context 'when there the user exists' do
      it 'get an user' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
        expect(json['email']).to eq(user_email)
      end
    end

    context 'when the user does not exits' do
      let(:user_id) { 1000 }

      it 'returns not found' do
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { email: 'valid@email.com', password: 'pw1234' } }

    context 'when the user can be successfully created' do
      before { post :create, params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status :created
      end

      it 'returns the created user' do
        expect(json['email']).to eq('valid@email.com')
      end
    end

    context 'when the request is invalid' do
      before { post :create, params: { email: 'invalid' } }

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'PUT #update' do
    let(:valid_attributes) { { id: user_id, email: 'update@email.com' } }

    context 'when the user exists' do
      before { 
        patch :update,
              params: valid_attributes,
              header: { Authorization: encoded_user_id }
      }

      it 'updates the user' do
        expect(json).not_to be_empty
        expect(json['email']).to eq('update@email.com')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { delete :destroy, params: { id: user_id } }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
