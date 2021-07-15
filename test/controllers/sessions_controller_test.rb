require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: 'Sam Smith',
                         email: 'sam@example.com',
                         password: 'welcome',
                         password_confirmation: 'welcome')
  end

  def test_should_login_user_with_valid_credentials
    post sessions_url, params: { login: { email: @user.email, password: @user.password } }, as: :json
    assert_response :success
    assert response.parsed_body['auth_token']
  end

  def test_shouldnt_login_user_with_invalid_credentials
    non_existent_email = 'this_email_does_not_exist_in_db@example.email'
    post sessions_url, params: { login: { email: non_existent_email, password: 'welcome' } }, as: :json

    assert_response :unauthorized
    assert_equal response.parsed_body['notice'], 'Incorrect credentials, try again.'
  end
end
