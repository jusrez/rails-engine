class Item < ApplicationRecord
  belongs_to :merchant

  def self.fuzzy_name_search(query)
    where('lower(name) LIKE ?', "%#{query.downcase}%")
    .order('name ASC')
  end

  def self.price_search(min = nil, max = nil)
    where('unit_price >= ?', min)
    .where('unit_price <= ?', max)
  end
  
end