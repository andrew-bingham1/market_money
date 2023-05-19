class Api::V0::MarketsController < ApplicationController

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
    rescue ActiveRecord::RecordNotFound
      record_not_found
  end

  def search
    state = params[:state]
    name = params[:name]
    city = params[:city]

    begin
      search = Market.validate_search_params(state, name, city)
      render json: MarketSerializer.new(search), status: :ok
    rescue ArgumentError
      render json: { errors: [{ detail: "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint." }] }, status: :unprocessable_entity
    end
  end

  def nearest_atms
    market = Market.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      record_not_found
    else
      facade = AtmFacade.new(market)
      atms = facade.atms
      render json: AtmSerializer.new(atms), status: :ok
  end

  private

  def record_not_found
    render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}" }] }, status: :not_found
  end
end