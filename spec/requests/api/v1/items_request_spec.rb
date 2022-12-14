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

      get "/api/v1/items/1526489"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

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
                    unit_price: 1.25,
                    merchant_id: merchant.id
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate({item: item_params})
      
      created_item = Item.last
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

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
                    name: "",
                    description: "",
                    unit_price: "hello world",
                    merchant_id: merchants.last.id
                    }
      headers = {"CONTENT_TYPE" => "application/json"}

      put "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

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

    it 'finds all items by name fragment' do
      merchant = create(:merchant)
      item1 = Item.create(name: "Ball", description: "A toy ball", unit_price: 5.50 , merchant_id: merchant.id)
      item2 = Item.create(name: "String", description: "A cloth string", unit_price: 3.25, merchant_id: merchant.id)
      item3 = Item.create(name: "Straw", description: "A metal toy", unit_price: 10.00, merchant_id: merchant.id)
      item4 = Item.create(name: "Hat", description: "A covering for your head", unit_price: 25.00, merchant_id: merchant.id)

      get '/api/v1/items/find_all?name=sT'

      expect(response).to be_successful
      items_matched = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items_matched.count).to eq(2)
      expect(items_matched[0][:id]).to eq(item3.id.to_s) 
      expect(items_matched[1][:id]).to eq(item2.id.to_s)
    end

    it 'finds one item by prices' do
      merchant = create(:merchant)
      item1 = Item.create(name: "Ball", description: "A toy ball", unit_price: 5.50 , merchant_id: merchant.id)
      item2 = Item.create(name: "String", description: "A cloth string", unit_price: 3.25, merchant_id: merchant.id)
      item3 = Item.create(name: "Straw", description: "A metal toy", unit_price: 10.00, merchant_id: merchant.id)
      item4 = Item.create(name: "Hat", description: "A covering for your head", unit_price: 25.00, merchant_id: merchant.id)

      get '/api/v1/items/find?name=ball&min_price=5'

      expect(response.status).to eq(400)

      get '/api/v1/items/find?name=ball&max_price=8'

      expect(response.status).to eq(400)

      get '/api/v1/items/find?min_price=-1'

      expect(response.status).to eq(400)

      get '/api/v1/items/find?max_price=-1'

      expect(response.status).to eq(400)
      
      get '/api/v1/items/find?min_price=5'
      
      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data][:id]).to eq(item1.id.to_s)

      get '/api/v1/items/find?max_price=5'
      
      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)
      
      expect(item[:data][:id]).to eq(item2.id.to_s)

      get '/api/v1/items/find?min_price=5&max_price=30'
      
      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)
      
      expect(item[:data][:id]).to eq(item1.id.to_s)
    end
end