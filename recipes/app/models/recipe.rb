# == Schema Information
#
# Table name: recipes
#
#  id          :bigint(8)        not null, primary key
#  name        :text             not null
#  notes       :text
#  url         :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint(8)
#

class Recipe < ApplicationRecord
  belongs_to :category

  validates :name, presence: true
  validate :ensure_url_or_notes

  def ensure_url_or_notes
    unless url.present? || notes.present?
      errors.add(:url, "one of url or notes must be present")
    end
  end
end
