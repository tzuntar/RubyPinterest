class Pin < ApplicationRecord
  #validates_presence_of :title
  has_many :comments, dependent: :destroy
  belongs_to :user
  has_and_belongs_to_many :boards, dependent: :destroy
  has_and_belongs_to_many :tags, dependent: :destroy
  accepts_nested_attributes_for :tags
  # has_many :comments, dependent: :destroy
  has_many :bookmarks
  has_many :users_who_saved, through: :bookmarks, source: :user
  acts_as_votable

  scope :filter_by_user, -> (user) { where user_id: user.id }
  scope :filter_by_tag, -> (tag) { joins(:tags).where(tags: { name: tag.strip.downcase }) }

  # very basic, use 'similar_pins' instead
  scope :similar_to_this, -> (pin) {
    where("UPPER(title) LIKE UPPER(:query) OR UPPER(description) LIKE UPPER(:query)", query: "%#{pin.title}%")
      .where("UPPER(title) LIKE UPPER(:query) OR UPPER(description) LIKE UPPER(:query)", query: "%#{pin.description}%")
      .where.not(id: pin.id)
      .where.not(title: [nil, ''])
      .where.not(description: [nil, ''])
      .limit(20)
  }

  def similar_pins
    similarity_matrix = Pin.similarity_matrix
    recommended_pins = Hash.new(0)

    Pin.all.each do |pin|
      similarity_matrix[pin.id].each do |other_pin_id, similarity|
        next if pin.id == id
        recommended_pins[other_pin_id] += similarity
      end
    end

    sorted = recommended_pins
               .sort_by { |id, score| -score }
               .map { |id, _| id }
    Pin.find(sorted)  # ToDo: .limit(20)
  end

  def vector
    title_weight = 0.3
    description_weight = 0.3
    tag_weight = 0.4

    title_vector = title.downcase.split(' ')
                        .each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
    description_vector = description.downcase.split(' ')
                                    .each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
    tag_vector = tags.each_with_object(Hash.new(0)) { |tag, counts| counts[tag.name.downcase] += 1 }

    vector = title_vector.merge(description_vector) { |key, val1, val2| title_weight * val1 + description_weight * val2 }
    vector.merge!(tag_vector) { |key, val1, val2| val1 + tag_weight * val2 }
  end

  # Calculate the similarity matrix between all pins
  def self.similarity_matrix
    pins = all
    similarity_matrix = Hash.new { |h, k| h[k] = {} }

    pins.each_with_index do |pin1, i|
      vector1 = pin1.vector

      pins.each_with_index do |pin2, j|
        next if j <= i

        vector2 = pin2.vector

        # Calculate cosine similarity between the vectors
        dot_product = vector1.keys.inject(0) { |acc, key| acc + vector1[key] * vector2[key].to_f }
        magnitude1 = Math.sqrt(vector1.values.inject(0) { |acc, val| acc + val ** 2 })
        magnitude2 = Math.sqrt(vector2.values.inject(0) { |acc, val| acc + val ** 2 })
        similarity_matrix[pin1.id][pin2.id] = dot_product / (magnitude1 * magnitude2)
        similarity_matrix[pin2.id][pin1.id] = similarity_matrix[pin1.id][pin2.id]
      end
    end

    similarity_matrix
  end

  include PgSearch::Model
  pg_search_scope :kinda_spelled_like,
                  against: [:title, :description],
                  using: :trigram
end
