class Merchant < ApplicationRecord
  has_many :items

  def self.fuzzy_search(query)
    where('lower(name) LIKE ?', "%#{query.downcase}%")
    .order('name ASC')
  end
end