require 'rails_helper'

RSpec.describe 'Items API' do
    it 'gets all items' do
      create_list(:merchant, 3)
      create_list(:item, 10)
      
      get '/api/v1/items'
      
      expect(response).to be_successful
      
      items = JSON.parse(response.body, symbolize_names: true) 
      
      expect(items[:data].count).to eq(10)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end

    it 'gets one item if the id is provided' do
      id = create(:item).id

      get "/api/v1/items/#{id}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)
      
      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to eq(id.to_s) 
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes]).to have_key(:merchant_id)
    end

    it 'creates a new item' do
      merchant = create(:merchant)
      item_params = ({
                    name: 'Lollipop',
                    description: 'A cherry flavored treat',
                    unit_price: 1.25,
                    merchant_id: merchant.id
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate({item: item_params})
      
      created_item = Item.last
      
      expect(response).to be_successful
      expect(response.status).to eq(201)

      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it 'deletes an item' do
      merchant = create(:merchant)
      item = create(:item)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(response.body).to eq("")
      expect(response.status).to eq(204)

      expect(item).to_not eq(Item.last)
    end
end