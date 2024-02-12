class Challenge < ApplicationRecord
  has_rich_text :description
  has_one_attached :test_file
  has_many :user_challenges
end
