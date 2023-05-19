require 'rails_helper'

RSpec.describe AtmFacade do
  it 'can make an atm poro' do
    market1 = Market.create(name: "Lowry Farmers' Market", street: "7581 East Academy Blvd.", city: "Denver", state: "CO", zip: "80230", lat: "39.7190269", lon: "-104.8969534")
    facade = AtmFacade.new(market1)
    
    expect(facade.atms).to be_a(Array)
    expect(facade.atms[0]).to be_a(Atm)

  end
end