class Pin < ApplicationRecord
  belongs_to :user
  belongs_to :board

  scope :filter_by_user, -> (user) { where user_id: user.user_id }
end
