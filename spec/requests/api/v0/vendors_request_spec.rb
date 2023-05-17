require 'rails_helper'

RSpec.describe 'Vendors API', type: :request do
  it 'sends a list of vendors for a given market' do
    market1 = FactoryBot.create(:market)
    market2 = FactoryBot.create(:market)

    vendor1 = FactoryBot.create(:vendor, credit_accepted: true)
    vendor2 = FactoryBot.create(:vendor, credit_accepted: true)
    vendor3 = FactoryBot.create(:vendor, credit_accepted: true)

    MarketVendor.create(market_id: market1.id, vendor_id: vendor1.id)
    MarketVendor.create(market_id: market1.id, vendor_id: vendor2.id)
    MarketVendor.create(market_id: market2.id, vendor_id: vendor3.id)

    get "/api/v0/markets/#{market1.id}/vendors"

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

    reply = JSON.parse(response.body, symbolize_names: true)

    expect(reply).to have_key(:errors)
    expect(reply[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=3")
  end

  it 'can return a vendor when given a vendor id' do
    vendor1 = FactoryBot.create(:vendor, credit_accepted: true)
    vendor2 = FactoryBot.create(:vendor, credit_accepted: true)

    get "/api/v0/vendors/#{vendor1[:id]}"

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

    reply = JSON.parse(response.body, symbolize_names: true)
    
    expect(reply).to have_key(:errors)
    expect(reply[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=1")
  end

  it 'can create a new vendor' do
    vendor_data = {
      name: 'Lembas by Legolas',
      description: 'One bite is enough to fill the stomach of a grown man',
      contact_name: 'Legolas',
      contact_phone: '123-456-7890',
      credit_accepted: true
    }

    post '/api/v0/vendors', params: { vendor: vendor_data }

    expect(response).to be_successful
    expect(response.status).to eq(201)

    new_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(new_vendor).to have_key(:data)
    expect(new_vendor[:data]).to be_a(Hash)

    expect(new_vendor[:data]).to have_key(:id)
    expect(new_vendor[:data][:id]).to be_a(String)

    expect(new_vendor[:data]).to have_key(:type)
    expect(new_vendor[:data][:type]).to eq('vendor')
    
    expect(new_vendor[:data]).to have_key(:attributes)
    expect(new_vendor[:data][:attributes]).to be_a(Hash)

    expect(new_vendor[:data][:attributes]).to have_key(:name)
    expect(new_vendor[:data][:attributes][:name]).to eq(vendor_data[:name])

    expect(new_vendor[:data][:attributes]).to have_key(:description)
    expect(new_vendor[:data][:attributes][:description]).to eq(vendor_data[:description])

    expect(new_vendor[:data][:attributes]).to have_key(:contact_name)
    expect(new_vendor[:data][:attributes][:contact_name]).to eq(vendor_data[:contact_name])

    expect(new_vendor[:data][:attributes]).to have_key(:contact_phone) 
    expect(new_vendor[:data][:attributes][:contact_phone]).to eq(vendor_data[:contact_phone])

    expect(new_vendor[:data][:attributes]).to have_key(:credit_accepted)
    expect(new_vendor[:data][:attributes][:credit_accepted]).to eq(vendor_data[:credit_accepted])
  end

  it 'returns a 400 if vendor is not created with details' do
    vendor_data = {
      name: "Gimli's Axes",
      description: 'Aye. I could do that'
    }

    post '/api/v0/vendors', params: { vendor: vendor_data }

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    reply = JSON.parse(response.body, symbolize_names: true)

    expect(reply).to have_key(:errors)
    expect(reply[:errors][0][:detail]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank, and Credit accepted is not included in the list")
  end

  it 'can update a vendor' do
    vendor1 = FactoryBot.create(:vendor, credit_accepted: true)

    vendor_data = {
      name: "Gimli's Axes",
      description: 'Aye. I could do that',
      contact_name: 'Gimli',
      contact_phone: '123-456-7890',
      credit_accepted: true
    }

    patch "/api/v0/vendors/#{vendor1[:id]}", params: { vendor: vendor_data }
    
    expect(response).to be_successful
    expect(response.status).to eq(200)

    updated_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(updated_vendor).to have_key(:data)
    expect(updated_vendor[:data]).to be_a(Hash)

    expect(updated_vendor[:data]).to have_key(:id)
    expect(updated_vendor[:data][:id]).to be_a(String)

    expect(updated_vendor[:data]).to have_key(:type)
    expect(updated_vendor[:data][:type]).to eq('vendor')

    expect(updated_vendor[:data]).to have_key(:attributes)
    expect(updated_vendor[:data][:attributes]).to be_a(Hash)
  end

  it 'returns a 400 if vendor is not updated with details' do
    vendor1 = FactoryBot.create(:vendor, credit_accepted: true)

    vendor_data = {
      name: '',
      description: '',
      contact_name: 'Gimli',
      contact_phone: '123-456-7890',
      credit_accepted: true
    }
    patch "/api/v0/vendors/#{vendor1[:id]}", params: { vendor: vendor_data }

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    reply = JSON.parse(response.body, symbolize_names: true)

    expect(reply).to have_key(:errors)
    expect(reply[:errors][0][:detail]).to eq("Validation failed: Name can't be blank and Description can't be blank")
  end

  it 'returns a 404 if vendor does not exist' do
    vendor_data = {
      name: "Gimli's Axes",
      description: 'Aye. I could do that',
      contact_name: 'Gimli',
      contact_phone: '123-456-7890',
      credit_accepted: true
    }

    patch "/api/v0/vendors/1", params: { vendor: vendor_data }

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    reply = JSON.parse(response.body, symbolize_names: true)

    expect(reply).to have_key(:errors)
    expect(reply[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=1")


  end


  it 'can delete a vendor' do
    @vendor1 = FactoryBot.create(:vendor, credit_accepted: false)

    delete "/api/v0/vendors/#{@vendor1[:id]}"

    expect(response).to be_successful
    expect(response.status).to eq(204)

    expect(Vendor.count).to eq(0)
  end

  it 'returns a 404 if vendor does not exist when deleting' do
    delete "/api/v0/vendors/1"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    reply = JSON.parse(response.body, symbolize_names: true)

    expect(reply).to have_key(:errors)
    expect(reply[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=1")
  end
end