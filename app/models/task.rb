class Task < ApplicationRecord
  before_validation :set_title, unless: :title_present
  before_validation :print_set_title
  validates :title, presence: true, length: { maximum: 50 }
  validates :slug, uniqueness: true
  validate :slug_not_changed

  before_create :set_slug
  # before_save :change_title
  # after_save :change_title
  belongs_to :user
  has_many :comments, dependent: :destroy

  def change_title
    self.title = "Pay electricity & TV bills"
  end

  def title_present
    self.title.present?
  end

  def set_title
    self.title = "pay electricity bill"
  end

  def print_set_title
    puts self.title
  end

  private

  def set_slug
    itr = 1
    loop do
      title_slug = title.parameterize
      slug_candidate = itr > 1 ? "#{title_slug}-#{itr}" : title_slug
      break self.slug = slug_candidate unless Task.exists?(slug: slug_candidate)

      itr += 1
    end
  end

  def slug_not_changed
    errors.add(:slug, t('task.slug.immutable')) if slug_changed? && persisted?
  end
end
