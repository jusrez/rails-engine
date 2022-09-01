require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
  end

  describe 'class methods' do
    it '.fuzzy_search' do
      merchant1 = Merchant.create!(name: "Samuel Adams")
      merchant2 = Merchant.create!(name: "Salvidor Dali")
      merchant3 = Merchant.create!(name: "Santa Claus")
      merchant4 = Merchant.create!(name: "Peter Rabbit")

      expect(Merchant.fuzzy_search("sA").first).to eq(merchant2)

    end
  end
end