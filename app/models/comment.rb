class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :pin
  validates_presence_of :body
end
