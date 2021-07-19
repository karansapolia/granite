require 'test_helper'

class UserNotificationTest < ActiveSupport::TestCase
  def setup
    user = User.create!(name: 'Sam Smith',
                        email: 'sam@example.com',
                        password: 'welcome',
                        password_confirmation: 'welcome')

    @user_notification = user.user_notifications.create!(last_notification_sent_date: Time.zone.today)
  end

  def test_last_notification_sent_date_must_be_present
    @user_notification.last_notification_sent_date = nil
    assert @user_notification.invalid?
    assert_includes @user_notification.errors.messages[:last_notification_sent_date], t('errors.messages.blank')
  end

  def test_last_notification_sent_date_must_be_parsable
    @user_notification.last_notification_sent_date = "12-13-2021"
    assert_equal @user_notification.last_notification_sent_date, nil
  end

  def test_last_notification_sent_date_cannot_be_in_past
    @user_notification.last_notification_sent_date = Time.zone.yesterday
    assert @user_notification.invalid?
    assert_includes @user_notification.errors.messages[:last_notification_sent_date], t('date.cant_be_in_past')
  end
end
