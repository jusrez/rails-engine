class Api::V1::ItemsSearchController < ApplicationController
  def index
    query = params[:name]
    results = Item.where('lower(name) LIKE ?', "%#{query.downcase}%")
    render json: ItemSerializer.new(results)
  end
end