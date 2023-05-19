class AtmFacade 
  def initialize(market)
    @market = market
  end

  def atms
    atm_data.map do |atm|
      Atm.new(atm)
    end

  end

  private 
  
  def atm_data
    service.get_atms(@market.lat, @market.lon)[:results]
  end

  def service 
    AtmService.new
  end
end