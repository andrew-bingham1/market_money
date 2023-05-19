require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'class methods' do
    it '::can validate search params' do
      market1 = Market.create!(name: "Market 1", state: "CO", city: "Denver")

      expect(Market.validate_search_params("CO", nil, nil)).to eq([market1])

      expect(Market.validate_search_params(nil, "Market 1", nil)).to eq([market1])

      expect { Market.validate_search_params(nil, nil, "Denver") }.to raise_error(ArgumentError)
    end
  end
end