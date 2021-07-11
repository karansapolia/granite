class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :slug, uniqueness: true
  validate :slug_not_changed

  before_create :set_slug

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
