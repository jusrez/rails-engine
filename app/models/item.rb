class Item < ApplicationRecord
  belongs_to :merchant

  def self.group_by_min_price(price)
    where('unit_price >= ?', price)
  end
end