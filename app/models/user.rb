class User < ActiveRecord::Base
  validates :name, presence: true

  # def self.search(query)
  #   where("name LIKE '%#{query}%'")
  # end

  scope :search, -> query { where("name LIKE '%#{query}%'") }
end