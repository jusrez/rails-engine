require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'gets all merchants' do
    create_list(:merchant, 7)

    get '/api/v1/merchants'
    
    expect(response).to be_successful
    
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(7)

    merchants[:data].each do |merchant| 
      expect(merchant).to have_key(:id)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'gets one merchant if id is given' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to eq(id.to_s)
  end

  it 'gets a merchants items' do
    id = create(:merchant).id
    create_list(:item, 5, merchant_id: id)

    get "/api/v1/merchants/#{id}/items"

    merchant_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant_items[:data].count).to eq(5)

    merchant_items[:data].each do |merchant_item|
      expect(merchant_item).to have_key(:id)
      expect(merchant_item[:attributes]).to have_key(:name)
      expect(merchant_item[:attributes]).to have_key(:description)
      expect(merchant_item[:attributes]).to have_key(:unit_price)
      expect(merchant_item[:attributes]).to have_key(:merchant_id)
    end
  end
end