class Api::V1::ItemsSearchController < ApplicationController
  def index
    query = params[:name]
    results = Item.fuzzy_name_search(query)
    render json: ItemSerializer.new(results)
  end

  def show
    if search_params[:name] && search_params[:min_price]
      render status: 400
    elsif search_params[:name] && search_params[:max_price]
      render status: 400
    elsif search_params[:min_price].to_f < 0 || search_params[:max_price].to_f < 0
      render json: { error: {}}, status: 400
    elsif search_params[:min_price] && search_params[:max_price]
      min = search_params[:min_price].to_f
      max = search_params[:max_price].to_f
      render json: ItemSerializer.new(Item.min_max_price_search(min, max).first)
    elsif search_params[:min_price]
      results = Item.min_price_search(search_params[:min_price].to_f)
      render json: { data: {}} if results.empty?
      render json: ItemSerializer.new(results.first) if results.empty? == false
    elsif search_params[:max_price]
      results = Item.max_price_search(search_params[:max_price].to_f)
      render json: { data: {}} if results.empty?
      render json: ItemSerializer.new(results.first) if results.empty? == false
    end
  end

  private

  def search_params
    params.permit(:name, :min_price, :max_price)
  end
end