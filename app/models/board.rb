class Board < ApplicationRecord

  has_and_belongs_to_many :pins, dependent: :destroy
  scope :filter_by_user, -> (user) { where user_id: user.user_id }

  include PgSearch
  pg_search_scope :kinda_spelled_like,
                  against: :title,
                  using: :trigram
end
