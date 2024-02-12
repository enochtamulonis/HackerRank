class UserChallenge < ApplicationRecord
  belongs_to :user
  belongs_to :challenge
  enum status: {
    in_progress: 0,
    completed: 1
  }
end
