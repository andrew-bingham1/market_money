class MarketVendor < ApplicationRecord
  belongs_to :vendor
  belongs_to :market

  validates :vendor_id, presence: { status: 400 }
  validates :market_id, presence: { status: 400 }

  validate :unique_market_vendor

  private 

  def unique_market_vendor
    if MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id)
      errors.add(:market_vendor, "association between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists")
    end
  end
end