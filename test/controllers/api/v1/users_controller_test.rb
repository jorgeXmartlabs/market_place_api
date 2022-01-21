require 'test_helper'

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
      end
      test 'should show user' do
        get api_v1_user_url(@user), as: :json
        assert_response :success
        # Test to ensure response contains the correct mail
        json_response = JSON.parse(self.response.body)
        assert_equal @user.email, json_response['email']
      end
    end
  end
end
