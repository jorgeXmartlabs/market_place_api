require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create :user }
  let(:user_id) { user.id }
  let(:user_email) { user.email }
  let(:serializer) { Api::V1::UserBlueprint }

  describe 'GET #show' do
    before { get :show, params: { id: user_id } }

    context 'when there the user exists' do
      it 'get an user' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user' do
        expect(json).to eql serializer.render_as_hash(user)
      end
    end

    context 'when the user does not exits' do
      let(:user_id) { 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
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

      it 'returns the user created' do
        expect(json).to eql serializer.render_as_hash(User.last)
      end
    end

    context 'when the request is invalid' do
      before { post :create, params: { email: 'invalid' } }

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns a validation failed message' do
        expect(response.body).to match(/Validation failed: Password can't be blank, Email is invalid, Password digest can't be blank/)
      end
    end
  end

  describe 'PUT #update' do
    let(:valid_attributes) { { id: user_id, email: 'updated@email.com' } }
    let(:old_user) { user }

    context 'when the user exists' do
      before { patch :update, params: valid_attributes }

      it 'should update the user' do
        expect(json['email']).not_to eq(old_user.email)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the user updated' do
        expect(json).to eql serializer.render_as_hash(valid_attributes)
      end
    end

    context 'when the user does not exists' do
      let(:invalid_attributes) { { id: 10000, email: 'updated@email.com' } }
      before { patch :update, params: invalid_attributes }

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'when the user exists' do
      before { delete :destroy, params: { id: user_id } }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the user does not exists' do
      before { delete :destroy, params: { id: 10000 } }

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end
end
