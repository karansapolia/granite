require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Sam Smith', email: 'sam@example.com', password: 'welcome', password_confirmation: 'welcome')
  end

  def test_user_should_be_not_valid_without_name
    @user.name = ''
    assert_not @user.valid?
    assert_equal ["Name can't be blank"], @user.errors.full_messages
  end

  def test_name_should_be_of_valid_length
    @user.name = "a" * 50
    assert @user.invalid?
  end

  def test_user_should_not_be_valid_and_saved_without_email
    @user.email = ""
    assert_not @user.valid?

    @user.save
    assert_equal ["Email can't be blank", "Email is invalid"], @user.errors.full_messages
  end

  def test_user_should_not_be_valid_and_saved_if_email_not_unique
    @uses.save!

    test_user = @user.dup
    assert_not test_user.valid?

    assert_equal ["Email has already been taken"], test_user.errors.full_messages
  end

  def test_reject_email_of_invalid_length
    @user.email = ("a" * 50) + "@test.com"
    assert @user.invalid?
  end

  def test_validation_should_accept_valid_emails
    valid emails = %w[user@example.com USER@example.COM US-ER@example.org first.last@example.in user+one@example.ac.in]

    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?
    end
  end

  def test_validation_should_reject_invalid_addresses
    invalid_emails = %w[user@exmaple,com user_at_example.org user.name@example. @sam-sam.com sam@sam+exam.com fishy+#.com]

    invalid_emails.each do |email|
      @user.email = email
      assert @user.invalid?
    end
  end

  def test_user_should_not_be_saved_without_password
    @user.password = nil
    assert_not @user.save
    assert_equal ["Password can't be blank"], @user.errors.full_messages
  end

  def test_user_should_match_password_and_password_confirmation
    @user.password_confirmation = ''
    assert_not @user.save
    assert_equal ["Password confirmation doesn't match Password"], @user.errors.full_messages
  end

  def test_user_should_have_unique_auth_token
    @user.save!
    second_user = User.create!(name: "Olive Sans", email: "olive@example.com", password: "welcome", password_confirmation: "welcome")

    assert_not_same @user.authentication_token, second_user.authentication_token
  end

  def test_preference_created_is_valid
    @user.save
    assert @user.preference.valid?
  end

  def test_notification_deilvery_hour_users_default_value
    @user.save
    assert_equal @user.preference.notification_delivery_hour, Constants::DEFAULT_NOTIFICATION_DELIVERY_HOUR
  end
end
