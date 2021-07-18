class UserNotification < ApplicationRecord
  belongs_to :user

  validates :last_notification_sent_date, presence: true
  validates :last_notification_sent_date_is_valid_date
  validates :last_notification_sent_date_cannot_be_in_the_past

  private

  def last_notification_sent_date_is_valid_date
    if last_notification_sent_date.present?
      Date.parse(last_notification_sent_date.to_s)
    end
  rescue ArgumentError
    errors.add(:last_notification_sent_date, t('date.valid'))
  end

  def last_notification_sent_date_cannot_be_in_the_past
    if last_notification_sent_date.present? &&
       last_notification_sent_date < Date.today
      errors.add(:last_notification_sent_date, t('date.cant_be_in_the_past'))
    end
  end
end
