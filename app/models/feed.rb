class Feed < ApplicationRecord
  validates_presence_of :recommendations
  belongs_to :user

  def pins
    recommendations = JSON.parse self.recommendations
    sorted = recommendations
               .sort_by { |_, score| -score }
               .map { |id, _| id }
    Pin.find(sorted)
  end

end
