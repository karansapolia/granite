class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 35 }
  has_many :tasks, dependent: :destroy
end
