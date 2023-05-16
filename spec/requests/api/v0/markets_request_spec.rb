require 'rails_helper'

RSpec.describe "Markets API", type: :request do
  it 'sends a list of markets' do
    create_list(:market, 5)

    get '/api/v0/markets'

    expect(response).to be_successful
    markets = JSON.parse(response.body, symbolize_names: true)
    markets = markets[:data]
    expect(markets.count).to eq(5)

    markets.each do |market|
      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)

      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)

      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)

      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_a(String)

      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_a(String)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_a(String)

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_a(String)

      expect(market[:attributes]).to have_key(:num_vendors)
      expect(market[:attributes][:num_vendors]).to be_a(Integer)
    end
  end

  it 'can get one market by its id' do
    @market = create(:market)

    get "/api/v0/markets/#{@market[:id]}"

    given_market = JSON.parse(response.body, symbolize_names: true)
    
    given_market = given_market[:data][:attributes]

    expect(response).to be_successful

    expect(given_market).to have_key(:name)
    expect(given_market[:name]).to be_a(String)

    expect(given_market).to have_key(:street)
    expect(given_market[:street]).to be_a(String)

    expect(given_market).to have_key(:city)
    expect(given_market[:city]).to be_a(String)

    expect(given_market).to have_key(:county)
    expect(given_market[:county]).to be_a(String)

    expect(given_market).to have_key(:state)
    expect(given_market[:state]).to be_a(String)

    expect(given_market).to have_key(:zip)
    expect(given_market[:zip]).to be_a(String)

    expect(given_market).to have_key(:lat)
    expect(given_market[:lat]).to be_a(String)
    
    expect(given_market).to have_key(:lon)
    expect(given_market[:lon]).to be_a(String)

    expect(given_market).to have_key(:num_vendors)
    expect(given_market[:num_vendors]).to be_a(Integer)
  end

  it 'returns an error if a market does not exist' do
    get '/api/v0/markets/1231231234'

    expect(response).to_not be_successful

    expect(response.status).to eq(404)

    reply =JSON.parse(response.body, symbolize_names: true)
    
    expect(reply).to have_key(:errors)
    expect(reply[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=1231231234")
  end
end