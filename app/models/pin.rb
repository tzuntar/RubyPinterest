class Pin < ApplicationRecord
  belongs_to :user
  belongs_to :board, optional: true

  scope :filter_by_user, -> (user) { where user_id: user.user_id }
end
