class Api::V1::ItemsController < ApplicationController

  def index
    if params[:controller] == 'api/v1/items'
      render json: ItemSerializer.new(Item.all)
    else
      render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
    end
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    else
      render status: 404
    end 
  end

  def destroy
    Item.find(params[:id]).destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end