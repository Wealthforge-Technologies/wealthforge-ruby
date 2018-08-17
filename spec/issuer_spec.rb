require "spec_helper"
require 'json'

describe WealthForge::Issuer do

  context 'issuer' do

    before do
      WealthForge.configure do |config|
        config.environment = 'ci'
      end
    end

    it "create issuer" do

      old_json = JSON['{
        "address": "124 Investor Way",
        "city": "Boston",
        "state": { "code": "VA" },
        "zip": "02139",
        "country": { "code": "US" },
        "busName": "LexShares",
        "bank":"lexshares_bank",
        "accountingFirm": "Accountants, LLC",
        "founderName": "James Smith",
        "firstName": "James",
        "lastName": "Smith",
        "stateOfFormation": { "code": "MD" },
        "entityType":  { "code": "ENTITY_TYPE_LLC"},
        "founderTitle": "CEO",
        "dateOfFormation": "2001-11-01",
        "ein": "999999999",
        "email": "wealthforge_api_test@mailinator.com",
        "phone": "2125551234",
        "sponsor": "cddee352-099b-494a-adb8-cc70b5cb86f6"
      }']

      response = WealthForge::Issuer.create old_json
      pp response
      expect(response['errors']).to eq nil
      end

    # it "get issuer" do
    #   VCR.use_cassette 'get_issuer', record: :all do
    #     response = WealthForge::Issuer.get "cc8033ee-cbd9-41b3-a02b-d4aa922a9829"
    #     expect(response[:data].size).to be > 0
    #     expect(response[:errors].length).to eq 0
    #   end
    # end



  end

end
