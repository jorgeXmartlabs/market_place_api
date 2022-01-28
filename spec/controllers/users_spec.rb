require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create :user }
  let(:user_id) { user.id }
  let(:user_email) { user.email }
  let(:serializer) { Api::V1::UserBlueprint }
  let(:encoded_user_id) { token_generator(user.id) }

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
    let(:valid_attributes) { { user: { email: 'valid@email.com', password: 'pw1234' } } }

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
      before { post :create, params: { user: { email: 'invalid' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns a validation failed message' do
        expect(response.body).to match(/Validation failed: Password can't be blank, Email is invalid, Password digest can't be blank/)
      end
    end
  end

  describe 'PUT #update' do
    let(:valid_attributes) { { id: user_id, user: { email: 'updated@email.com' } } }
    let(:old_user) { user }
    let(:headers) { { 'Authorization' => token_generator(user.id) } }

    context 'when the user exists' do
      let(:valid_attributes) { { id: user_id, user: { email: 'updated@email.com' } } }
      before do
        request.headers['Authorization'] = token_generator(user.id)
        patch :update, params: valid_attributes
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should update the user' do
        expect(json['email']).not_to eq(old_user.email)
      end

      it 'returns the user updated' do
        expect(json).to eql serializer.render_as_hash({ email: 'updated@email.com', id: user_id })
      end

    end

    context 'when the user does not exists' do
      let(:invalid_attributes) { { id: 10000, user: { email: 'updated@email.com' } } }
      before do
        request.headers['Authorization'] = token_generator(user.id)
        patch :update, params: invalid_attributes
      end

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
      before do
        request.headers['Authorization'] = token_generator(user.id)
        delete :destroy, params: { id: user_id }
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the user does not exists' do
      before do
        request.headers['Authorization'] = token_generator(user.id)
        delete :destroy, params: { id: 10000 }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end
end
