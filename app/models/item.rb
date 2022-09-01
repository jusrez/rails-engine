class Item < ApplicationRecord
  belongs_to :merchant

  def self.fuzzy_name_search(query)
    where('lower(name) LIKE ?', "%#{query.downcase}%")
    .order('name ASC')
  end

  def self.group_by_min_price(price)
    where('unit_price >= ?', price)
  end

  
end