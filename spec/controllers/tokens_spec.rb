require 'rails_helper'

RSpec.describe Api::V1::TokensController, type: :controller do
  let!(:user) { create(:user) }
  let(:token) { token_generator(user.id) }
  let(:serializer) { Api::V1::TokenBlueprint }

  describe 'POST #create' do
    let(:valid_attributes) { { email: user.email, password: user.password } }
    let(:invalid_attributes) { { email: 'invalid@email.com', password: user.password } }

    context 'when the token can be successfully created' do
      before { post :create, params: { user: valid_attributes } }

      it 'returns status code 200' do
        expect(response).to have_http_status :ok
      end

      it 'returns the token and email' do
        expect(json).to eql serializer.render_as_hash({ email: user.email, token: token })
      end
    end

    context 'when the token cannot be created' do
      before { post :create, params: { user: invalid_attributes } }

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
      end

      it 'returns an empty response.body' do
        expect(response.body).to match(//)
      end
    end
  end
end
