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

    it 'updates an item' do
      merchants = create_list(:merchant, 2)
      id = create(:item, merchant_id: merchants.first.id).id
      previous_item = Item.last
      item_params = {
                    name: "Juicy Fruit",
                    description: "Best bubblegum in the world",
                    unit_price: 3.25,
                    merchant_id: merchants.last.id
                    }
      headers = {"CONTENT_TYPE" => "application/json"}

      put "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(response.status).to eq(202)

      expect(item.name).to eq("Juicy Fruit")
      expect(item.description).to eq("Best bubblegum in the world")
      expect(item.unit_price).to eq(3.25)
      expect(item.merchant_id).to eq(merchants.last.id)
    end

    it 'get an items merchant' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful
      
      item_merchant = JSON.parse(response.body, symbolize_names: true)
  
      expect(item_merchant[:data][:id]).to eq(merchant.id.to_s)
    end
end