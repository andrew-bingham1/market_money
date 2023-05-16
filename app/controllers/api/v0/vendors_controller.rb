class Api::V0::VendorsController < ApplicationController

  def index
    render json: VendorSerializer.new(Market.find(params[:market_id]).vendors) 
    rescue ActiveRecord::RecordNotFound
      record_not_found_index
  end

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
    rescue ActiveRecord::RecordNotFound
      record_not_found_show
  end


  private

  def record_not_found_index
    render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:market_id]}" }] }, status: :not_found
  end

  def record_not_found_show
    render json: { errors: [{ detail: "Couldn't find Vendor with 'id'=#{params[:id]}" }] }, status: :not_found
  end
end