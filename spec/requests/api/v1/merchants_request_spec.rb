require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'shows a list of all merchants' do
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
end