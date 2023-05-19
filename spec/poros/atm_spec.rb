require 'rails_helper'

RSpec.describe Atm do
  it 'exists' do
    attrs = {
              type: "POI",
              id: "SIlo6IvDUNQvWFetmLBucA",
              score: 2.8319687742,
              dist: 184.410519,
              info: "search:ta:840089001016279-US",
              poi: {
                name: "ATM at Space Age Federal Credit Union",
                categorySet: [
                  {
                    id: 7397
                  }
                ],
                categories: [
                  "cash dispenser"
                ],
                classifications: [
                  {
                    code: "CASH_DISPENSER",
                    names: [
                      {
                        nameLocale: "en-US",
                        name: "cash dispenser"
                      }
                    ]
                  }
                ]
              },
              address: {
                streetNumber: "130",
                streetName: "North Rampart Way",
                municipalitySubdivision: "Lowry Field",
                municipality: "Denver",
                countrySecondarySubdivision: "Denver",
                countrySubdivision: "CO",
                countrySubdivisionName: "Colorado",
                postalCode: "80230",
                extendedPostalCode: "80230-6404",
                countryCode: "US",
                country: "United States",
                countryCodeISO3: "USA",
                freeformAddress: "130 North Rampart Way, Denver, CO 80230",
                localName: "Denver"
              },
              position: {
                lat: 39.720263,
                lon: -104.898391
              },
              viewport: {
                topLeftPoint: {
                  lat: 39.72116,
                  lon: -104.89956
                },
                btmRightPoint: {
                  lat: 39.71936,
                  lon: -104.89722
                }
              },
              entryPoints: [
                {
                  type: "main",
                  position: {
                    lat: 39.72024,
                    lon: -104.89844
                  }
                }
              ]
            }


    atm = Atm.new(attrs)

    expect(atm).to be_a(Atm)
    expect(atm.name).to eq("ATM at Space Age Federal Credit Union")
    expect(atm.address).to eq("130 North Rampart Way, Denver, CO 80230")
    expect(atm.lat).to eq(39.720263)
    expect(atm.lon).to eq(-104.898391)
    expect(atm.distance).to eq(184.410519)
  end
end