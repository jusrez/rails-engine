class Api::V1::MerchantsSearchController < ApplicationController
  def show
    query = params[:name]
    results = Merchant.fuzzy_search(query)
    if results.empty?
      render json: { data: {}}
    else
      render json: MerchantSerializer.new(results.first)
    end
  end
end