require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }
  let!(:existed_user) { create(:existed_user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is invalid with bad email format' do
      user.email = 'bad_formatted_email'
      expect(user).not_to be_valid
    end

    it 'is invalid with no password presence' do
      user.password_digest = ''
      expect(user).not_to be_valid
    end

    it 'is invalid with no email presence' do
      user.email = ''
      expect(user).not_to be_valid
    end

    it 'is invalid with email not unique' do
      user.email = 'existed_user@email.com'
      expect(user).not_to be_valid
    end
  end
end
