require 'faraday'

class AtmService
  def conn
    Faraday.new(url: 'https://api.tomtom.com')
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_atms(lat, lon)
    get_url("/search/2/categorySearch/atm.json?key=#{ENV['TOMTOM_API_KEY']}&lat=#{lat}&lon=#{lon}")
  end
end