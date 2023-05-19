class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  validates_presence_of :name

  def self.validate_search_params(state, name, city)
    if state.nil? && city.present? && name.present?
      raise ArgumentError
    end
    if state.present?
      if city.present?
        if name.present?
          Market.where("lower(state) LIKE ? AND lower(city) LIKE ? AND lower(name) LIKE ?", "%#{state.downcase}%", "%#{city.downcase}%", "%#{name.downcase}%")
        else
          Market.where("lower(state) LIKE ? AND lower(city) LIKE ?", "%#{state.downcase}%", "%#{city.downcase}%")
        end
      elsif name.present?
        Market.where("lower(state) LIKE ? AND lower(name) LIKE ?", "%#{state.downcase}%", "%#{name.downcase}%")
      else
        Market.where("lower(state) LIKE ?", "%#{state.downcase}%")
      end
    elsif name.present?
      Market.where("lower(name) LIKE ?", "%#{name.downcase}%")
    else
      raise ArgumentError
    end
  end
end