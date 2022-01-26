require 'rails_helper'

RSpec.describe 'Api::V1::Tokens', type: :request do

  let(:user) { build :user }
  let!(:existed_user) { create(:existed_user) }

=begin
  describe 'create a token' do
    subject { post api_v1_tokens_path, params: { user: params } }

    context 'when the token can be successfully created' do
      let(:params) { attributes_for :existed_user }

      before(:each) { subject }

      it 'returns success' do
        expect(response).to have_http_status :ok
      end
    end
  end
=end

end
