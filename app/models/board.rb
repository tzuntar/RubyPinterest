class Board < ApplicationRecord
  has_many :pins, dependent: :destroy

  scope :filter_by_user, -> (user) { where user_id: user.user_id }
end
