require 'rails_helper'

RSpec.describe 'Market Vendors API', type: :request do
  it 'can create a new market vendor entry' do
    market = FactoryBot.create(:market)
    vendor = FactoryBot.create(:vendor, credit_accepted: true)
    market_vendor_params = { market_id: market.id, vendor_id: vendor.id }

    post '/api/v0/market_vendors', params: { market_vendor: market_vendor_params }

    expect(response).to be_successful
    expect(response.status).to eq(201)

    reply = JSON.parse(response.body, symbolize_names: true)

    expect(reply).to have_key(:message)
    expect(reply[:message]).to eq("Successfully added vendor to market")

    get "/api/v0/markets/#{market.id}/vendors"

    reply = JSON.parse(response.body, symbolize_names: true)

    expect(reply[:data][0][:attributes][:name]).to eq(vendor.name)
  end

  it 'returns a 404 if market does not exist' do
    @vendor = FactoryBot.create(:vendor, credit_accepted: true)
    market_vendor_params = { market_id: 1, vendor_id: @vendor.id }

    post '/api/v0/market_vendors', params: { market_vendor: market_vendor_params }

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    reply = JSON.parse(response.body, symbolize_names: true)

    expect(reply).to have_key(:errors)
    expect(reply[:errors][0][:detail]).to eq("Validation failed: Market and Vendor must exist")
  end

  it 'returns a 422 if the record already exists' do
    market = FactoryBot.create(:market)
    vendor = FactoryBot.create(:vendor, credit_accepted: true)
    MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
 
    market_vendor_params = { market_id: market.id, vendor_id: vendor.id }

    post '/api/v0/market_vendors', params: { market_vendor: market_vendor_params }

    # expect(response).to_not be_successful
    expect(response.status).to eq(422)

    reply = JSON.parse(response.body, symbolize_names: true)

    expect(reply).to have_key(:errors)
    expect(reply[:errors][0][:detail]).to eq("Validation failed: Market vendor association between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
  end

end