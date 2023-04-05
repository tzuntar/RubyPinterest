class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :boards, dependent: :destroy
  has_many :pins, through: :boards, dependent: :destroy

  include PgSearch
  pg_search_scope :kinda_spelled_like,
                  against: :name,
                  using: :trigram
end
