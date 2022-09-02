class Item < ApplicationRecord
  belongs_to :merchant

  def self.fuzzy_name_search(query)
    where('lower(name) LIKE ?', "%#{query.downcase}%")
    .order('name ASC')
  end

  def self.min_price_search(price)
    where('unit_price >= ?', price)
    .order('name ASC')
  end

  def self.max_price_search(price)
    where('unit_price <= ?', price)
    .order('name ASC')
  end

  def self.min_max_price_search(min, max)
    where('unit_price >= ?', min)
    .where('unit_price <= ?', max)
    .order('name ASC')
  end
  
end