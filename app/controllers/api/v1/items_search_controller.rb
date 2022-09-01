class Api::V1::ItemsSearchController < ApplicationController
  def index
    query = params[:name]
    results = Item.fuzzy_name_search(query)
    render json: ItemSerializer.new(results)
  end
end