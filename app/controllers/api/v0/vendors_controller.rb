class Api::V0::VendorsController < ApplicationController

  def index
    render json: VendorSerializer.new(Market.find(params[:market_id]).vendors), status: :ok
    rescue ActiveRecord::RecordNotFound
      record_not_found_index
  end

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id])), status: :ok
    rescue ActiveRecord::RecordNotFound
      record_not_found_show
  end

  def create
    new_vendor = Vendor.new(vendor_params)
    if new_vendor.save
      render json: VendorSerializer.new(Vendor.last), status: :created
    else
      render json: { errors: [{ detail: "Validation failed: #{new_vendor.errors.full_messages.to_sentence}" }] }, status: :bad_request
    end
  end

  def update
    vendor = Vendor.find(params[:id])
    if vendor.update(vendor_params)
      render json: VendorSerializer.new(vendor), status: :ok
    else
      render json: { errors: [{ detail: "Validation failed: #{vendor.errors.full_messages.to_sentence}" }] }, status: :bad_request
    end
    rescue ActiveRecord::RecordNotFound
      record_not_found_show
  end

  def destroy
    Vendor.find(params[:id]).destroy 
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

  def vendor_params
    params.require(:vendor).permit(:name,
                                   :description,
                                   :contact_name,
                                   :contact_phone,
                                   :credit_accepted)
  end
end