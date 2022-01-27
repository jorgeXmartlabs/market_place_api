require 'rails_helper'

RSpec.describe 'Api::V1::Tokens', type: :request do
  let(:user) { build :user }
  let!(:existed_user) { create(:existed_user) }

  describe 'POST /api/v1/tokens' do
    let(:valid_attributes) { { email: existed_user.email, password: existed_user.password } }
    let(:invalid_attributes) { { email: 'invalid@email.com', password: 'pw1234' } }

    context 'when the token can be successfully created' do
      before { post '/api/v1/tokens', params: { user: valid_attributes } }

      it 'returns status code 200' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when the token cannot be created' do
      before { post '/api/v1/tokens', params: { user: invalid_attributes } }

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

end
