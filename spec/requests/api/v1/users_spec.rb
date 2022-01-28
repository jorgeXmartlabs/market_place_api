require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create :user }
  let(:user_id) { user.id }
  let(:user_email) { user.email }
  let(:serializer) { Api::V1::UserBlueprint }
  let(:headers) { { 'Authorization' => token_generator(user_id) } }

  describe 'GET /users/:id' do
    before { get api_v1_user_path(user_id) }

    context 'when there is an user with that specific id' do
      it 'returns status code 200' do
        expect(response).to have_http_status :ok
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

  describe 'POST /users' do
    let(:valid_attributes) { { user: { email: 'valid@email.com', password: 'pw1234' } } }

    context 'when the user can be successfully created' do
      before { post api_v1_users_path, params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status :created
      end

      it 'returns the user created' do
        expect(json).to eql serializer.render_as_hash(User.last)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/users', params: { user: { email: 'invalid' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns a validation failed message' do
        expect(response.body).to match(/Validation failed: Password can't be blank, Email is invalid, Password digest can't be blank/)
      end
    end
  end

  describe 'PUT /users/:id' do
    let(:valid_attributes) { { id: user_id, user: { email: 'updated@email.com' } } }
    let(:old_user) { user }

    context 'when the user exists' do
      before { put api_v1_user_path(user_id), params: valid_attributes, headers: headers }

      it 'should update the user' do
        expect(json['email']).not_to eq(old_user.email)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the user updated' do
        expect(json).to eql serializer.render_as_hash({ email: 'updated@email.com', id: user_id })
      end
    end

    context 'when the user does not exists' do
      let(:invalid_attributes) { { id: user_id, user: { email: 'updated@email.com' } } }
      before { put api_v1_user_path(10_000), params: invalid_attributes, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  describe 'DELETE /users/:id' do

    context 'when the user exists' do
      before { delete api_v1_user_path(user_id), headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the user does not exists' do
      before { delete api_v1_user_path(10_000) }

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end
end
