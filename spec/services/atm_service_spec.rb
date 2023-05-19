require 'rails_helper'

RSpec.describe AtmService do
  it 'can get atms' do
      service = AtmService.new
      atms = service.get_atms(39.7392, -104.9903)
      expect(atms).to be_a(Hash)
      expect(atms).to have_key(:results)
  end
end