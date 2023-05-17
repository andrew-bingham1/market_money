class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def create
    Vendor.find(market_vendor_params[:vendor_id])
    Market.find(market_vendor_params[:market_id])
    new_market_vendor = MarketVendor.new(market_vendor_params)
    if new_market_vendor.save
      render json: { message: "Successfully added vendor to market" }, status: :created
    else
      render json: { errors: [{ detail: "Validation failed: #{new_market_vendor.errors.full_messages.to_sentence}" }] }, status: :unprocessable_entity
    end
  end

  private 

  def record_not_found
    render json: { errors: [{ detail: "Validation failed: Market and Vendor must exist" }] }, status: :not_found
  end

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end
end