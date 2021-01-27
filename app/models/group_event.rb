class GroupEvent < ApplicationRecord
  # validations
  validates :duration, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :name, :description, :location, :duration, :start_at, presence: true, unless: :is_draft?

  # scopes
  scope :draft, -> { where(is_draft: true) }
  scope :published, -> { where(is_draft: false) }
  scope :deleted, -> { where(is_deleted: true) }

  # instance methods
  def end_at
    return if start_at.nil? || duration.nil?

    start_at + duration
  end

  def mark_as_deleted
    update(is_deleted: true)
  end

  def mark_as_published
    update(is_draft: false)
  end
end
