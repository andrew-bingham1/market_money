class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: Market.find(params[:id])
  end

  private

  def record_not_found
    render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}" }] }, status: :not_found
  end
end