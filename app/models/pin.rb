class Pin < ApplicationRecord
  #validates_presence_of :title
  belongs_to :user
  belongs_to :board, optional: true
  has_and_belongs_to_many :tags, dependent: :destroy
  accepts_nested_attributes_for :tags
  # has_many :comments, dependent: :destroy
  has_many :bookmarks
  has_many :users_who_saved, through: :bookmarks, source: :user

  scope :filter_by_user, -> (user) { where user_id: user.user_id }
  scope :filter_by_tag, -> (tag) { joins(:tags).where(tags: { name: tag.strip.downcase }) }
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
