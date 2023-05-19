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

      expect(market[:attributes]).to have_key(:vendor_count)
      expect(market[:attributes][:vendor_count]).to be_a(Integer)
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

    expect(given_market).to have_key(:vendor_count)
    expect(given_market[:vendor_count]).to be_a(Integer)
  end

  it 'returns an error if a market does not exist' do
    get '/api/v0/markets/1231231234'

    expect(response).to_not be_successful

    expect(response.status).to eq(404)

    reply =JSON.parse(response.body, symbolize_names: true)
    
    expect(reply).to have_key(:errors)
    expect(reply[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=1231231234")
  end

  it 'can search for a market' do 
    market1 = Market.create(name: "Denver Market", street: "123 Main St", city: "Denver", state: "CO", zip: "80202", lat: "39.750783", lon: "-104.996439")
    market2 = Market.create(name: "Lakewood Market", street: "456 Main St", city: "Lakewood", state: "CO", zip: "12345", lat: "39.750783", lon: "-104.996439")
    market3 = Market.create(name: "Binghamton Market", street: "789 Main St", city: "Binghamton", state: "NY", zip: "13827", lat: "39.750783", lon: "-104.996439")

    
    get "/api/v0/markets/search", params: { state: "NY"}

    expect(response).to be_successful
    expect(response.status).to eq(200)
    
    reply = JSON.parse(response.body, symbolize_names: true)

    expect(reply[:data].count).to eq(1)

    expect(reply[:data][0][:attributes]).to have_key(:name)
    expect(reply[:data][0][:attributes][:name]).to be_a(String)
    expect(reply[:data][0][:attributes][:name]).to eq(market3.name)

    get "/api/v0/markets/search", params: { state: "CO", city: "Denver"}

    expect(response).to be_successful
    expect(response.status).to eq(200)

    get "/api/v0/markets/search", params: { state: "CO", city: "Denver", name: "Denver Market"}

    expect(response).to be_successful
    expect(response.status).to eq(200)

    get "/api/v0/markets/search", params: { state: "CO",  name: "Denver Market"}

    expect(response).to be_successful
    expect(response.status).to eq(200)

    get "/api/v0/markets/search", params: { name: "Denver Market"}
    
    expect(response).to be_successful
    expect(response.status).to eq(200)
  end

  it 'returns a 422 if invalid params are sent' do
    get "/api/v0/markets/search", params: { city: "Denver" }

    expect(response).to_not be_successful
    expect(response.status).to eq(422)

    get "/api/v0/markets/search", params: { city: "Denver", name: "Something Cool" }

    expect(response).to_not be_successful
    expect(response.status).to eq(422)
  end

  it 'still returns 200 even if there are no matches with data key' do
    get "/api/v0/markets/search", params: { state: "NY"}

    expect(response).to be_successful
    expect(response.status).to eq(200)

    reply = JSON.parse(response.body, symbolize_names: true)

    expect(reply).to have_key(:data)
  end

  it 'can return a list of nearest atms' do
    market1 = Market.create(name: "Lowry Farmers' Market", street: "7581 East Academy Blvd.", city: "Denver", state: "CO", zip: "80230", lat: "39.7190269", lon: "-104.8969534")

    get "/api/v0/markets/#{market1.id}/nearest_atms"

    expect(response).to be_successful
    expect(response.status).to eq(200)

    reply = JSON.parse(response.body, symbolize_names: true)

    expect(reply).to have_key(:data)
  end

  it 'returns an error if a market does not exist' do
    get '/api/v0/markets/1231231234/nearest_atms'

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

end