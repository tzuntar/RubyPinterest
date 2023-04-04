class Pin < ApplicationRecord
  belongs_to :user
  belongs_to :board, optional: true
  # has_many :comments, dependent: :destroy

  scope :filter_by_user, -> (user) { where user_id: user.user_id }
  scope :similar_to_this, -> (pin) {
    where("UPPER(title) LIKE UPPER(:query) OR UPPER(description) LIKE UPPER(:query)", query: "%#{pin.title}%")
      .where("UPPER(title) LIKE UPPER(:query) OR UPPER(description) LIKE UPPER(:query)", query: "%#{pin.description}%")
      .where.not(id: pin.id)
      .where.not(title: [nil, ''])
      .where.not(description: [nil, ''])
      .limit(20)
  }

  include PgSearch
  pg_search_scope :kinda_spelled_like,
                  against: :title,
                  using: :trigram
end
