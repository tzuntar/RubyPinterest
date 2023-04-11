class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :boards, dependent: :destroy
  has_many :pins, through: :boards, dependent: :destroy
  has_many :bookmarks
  has_many :saved_pins, through: :bookmarks, source: :pin
  has_one :feed, dependent: :destroy

  def recommended_pins
    sorted = calculate_recommended_pins
      .sort_by { |_, score| -score }
      .map { |id, _| id }
    Pin.find(sorted)
  end

  def calculate_recommended_pins
    bookmarked_pins = bookmarks.map(&:pin)
    similarity_matrix = Pin.similarity_matrix
    recommended_pins = Hash.new(0)

    Pin.all.each do |pin|
      similarity_matrix[pin.id].each do |other_pin_id, similarity|
        next if bookmarked_pins.pluck(:id).include?(other_pin_id) # skip pins the user has already bookmarked
        recommended_pins[other_pin_id] += similarity
      end
    end
    recommended_pins
  end

  include PgSearch
  pg_search_scope :kinda_spelled_like,
                  against: :name,
                  using: :trigram
end
