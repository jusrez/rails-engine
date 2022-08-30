class Api::V1::ItemsController < ApplicationController
  def index
    if params[:controller] == 'api/v1/items'
      render json: ItemSerializer.new(Item.all)
    else
      render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
    end
  end
end