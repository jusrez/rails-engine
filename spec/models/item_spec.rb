require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'class methods' do
    it '.fuzzy_name_search' do
      merchant = create(:merchant)
      item1 = Item.create!(name: 'Toy', description: 'A childs toy', unit_price: 12.50, merchant_id: merchant.id)
      item2 = Item.create!(name: 'Torch', description: 'Fire!', unit_price: 25.50, merchant_id: merchant.id)
      item3 = Item.create!(name: 'Hula Hoop', description: 'A round circle that requires rhythm to use', unit_price: 40.00, merchant_id: merchant.id)
      item4 = Item.create!(name: 'Water Gun', description: 'A plastic device used to spray water', unit_price: 32.50, merchant_id: merchant.id)

      expect(Item.fuzzy_name_search('tO')).to eq([item2, item1])
      expect(Item.fuzzy_name_search('tO').first).to eq(item2)
      expect(Item.fuzzy_name_search('tO').last).to eq(item1)
    end

    it '.min_price_search' do
      merchant = create(:merchant)
      item1 = Item.create!(name: 'Toy', description: 'A childs toy', unit_price: 12.50, merchant_id: merchant.id)
      item2 = Item.create!(name: 'Ball', description: 'A bouncy ball', unit_price: 25.50, merchant_id: merchant.id)
      item3 = Item.create!(name: 'Hula Hoop', description: 'A round circle that requires rhythm to use', unit_price: 40.00, merchant_id: merchant.id)
      item4 = Item.create!(name: 'Water Gun', description: 'A plastic device used to spray water', unit_price: 32.50, merchant_id: merchant.id)

      expect(Item.min_price_search(30)).to eq([item3, item4])
    end

    it '.max_price_search' do
      merchant = create(:merchant)
      item1 = Item.create!(name: 'Toy', description: 'A childs toy', unit_price: 12.50, merchant_id: merchant.id)
      item2 = Item.create!(name: 'Ball', description: 'A bouncy ball', unit_price: 25.50, merchant_id: merchant.id)
      item3 = Item.create!(name: 'Hula Hoop', description: 'A round circle that requires rhythm to use', unit_price: 40.00, merchant_id: merchant.id)
      item4 = Item.create!(name: 'Water Gun', description: 'A plastic device used to spray water', unit_price: 32.50, merchant_id: merchant.id)

      expect(Item.max_price_search(15.25)).to eq([item1])
    end


    it '.min_max_price_search' do
      merchant = create(:merchant)
      item1 = Item.create!(name: 'Toy', description: 'A childs toy', unit_price: 12.50, merchant_id: merchant.id)
      item2 = Item.create!(name: 'Ball', description: 'A bouncy ball', unit_price: 25.50, merchant_id: merchant.id)
      item3 = Item.create!(name: 'Hula Hoop', description: 'A round circle that requires rhythm to use', unit_price: 40.00, merchant_id: merchant.id)
      item4 = Item.create!(name: 'Water Gun', description: 'A plastic device used to spray water', unit_price: 32.50, merchant_id: merchant.id)

      expect(Item.min_max_price_search(10.15, 26)).to eq([item2, item1])
    end
  end
end