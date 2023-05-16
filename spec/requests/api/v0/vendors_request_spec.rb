require 'rails_helper'

RSpec.describe 'Vendors API', type: :request do
  it 'sends a list of vendors for a given market' do
    @market1 = FactoryBot.create(:market)
    @market2 = FactoryBot.create(:market)

    @vendor1 = FactoryBot.create(:vendor, credit_accepted: true)
    @vendor2 = FactoryBot.create(:vendor, credit_accepted: true)
    @vendor3 = FactoryBot.create(:vendor, credit_accepted: true)

    MarketVendor.create(market_id: @market1.id, vendor_id: @vendor1.id)
    MarketVendor.create(market_id: @market1.id, vendor_id: @vendor2.id)
    MarketVendor.create(market_id: @market2.id, vendor_id: @vendor3.id)

    get "/api/v0/markets/#{@market1.id}/vendors"

    expect(response).to be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)
    vendors = vendors[:data]

    expect(vendors.count).to eq(2)

    vendors.each do |vendor|
      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to be_in([true, false])
    end
  end

  it 'returns a 404 if market does not exist' do
    get '/api/v0/markets/3/vendors'

    expect(response).to_not be_successful

    expect(response.status).to eq(404)

    reply =JSON.parse(response.body, symbolize_names: true)

    expect(reply).to have_key(:errors)
    expect(reply[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=3")
  end

  it 'can return a vendor when given a vendor id' do
    @vendor1 = FactoryBot.create(:vendor, credit_accepted: true)
    @vendor2 = FactoryBot.create(:vendor, credit_accepted: true)

    get "/api/v0/vendors/#{@vendor1[:id]}"

    given_vendor = JSON.parse(response.body, symbolize_names: true)
    
    given_vendor = given_vendor[:data][:attributes]

    expect(response).to be_successful

    expect(given_vendor).to have_key(:name)
    expect(given_vendor[:name]).to be_a(String)

    expect(given_vendor).to have_key(:description)
    expect(given_vendor[:description]).to be_a(String)

    expect(given_vendor).to have_key(:contact_name)
    expect(given_vendor[:contact_name]).to be_a(String)

    expect(given_vendor).to have_key(:contact_phone)
    expect(given_vendor[:contact_phone]).to be_a(String)

    expect(given_vendor).to have_key(:credit_accepted)
    expect(given_vendor[:credit_accepted]).to be_in([true, false])
  end

  it 'returns a 404 if vendor does not exist' do
    get '/api/v0/vendors/1'

    expect(response).to_not be_successful

    expect(response.status).to eq(404)

    reply =JSON.parse(response.body, symbolize_names: true)
    
    expect(reply).to have_key(:errors)
    expect(reply[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=1")
  end
end