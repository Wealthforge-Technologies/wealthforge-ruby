require 'spec_helper'
require 'pp'

describe WealthForge::Offering do

  context 'offering' do

    before do
      WealthForge.configure do |config|
        config.environment = 'ci'
      end
    end

    it "create OLD offering" do
      old_json = JSON['{
        "issuer":"d6ee188a-f186-41f6-a069-c51b09d73fc2",
        "totalShare":1000000,
        "previouslyRaised":0,
        "minRaise":999999,
        "maxRaise":1000000,
        "offerDetails":[
            {
                "minInvestment":50000,
                "minRaise":999999,
                "maxRaise":1000000,
                "issued":1000000,
                "price":1,
                "postMoneyValuation":1000000,
                "offerDetailType":"EQUITY",
                "instrumentType":"SHARE_COMMON",
                "regulationType":"MEMO_EQUITY_D506C",
                "paymentMethods": ["ACH", "WIRE"],
                "title": "The ABC Offering",
                "classTitle": "ABC debt loan terms (3 yr, 5 yr)"
            }
        ],
        "status":"OFFERING_PENDING",
        "dateStart":"2019-03-05",
        "dateEnd":"2020-05-06"
      }']

      # VCR.use_cassette 'create_offering', record: :none do
      response = WealthForge::Offering.create old_json
      pp response
      expect(response['errors']).to eq nil
      # end
    end


    # it "get offering" do
    #   # VCR.use_cassette 'get_offering_by_id', record: :none do
    #   response = WealthForge::Offering.get 'cf99116c-1209-47a7-a52a-46332ed7245f'
    #   pp JSON.parse response.env.body
    #   expect(response.status).not_to be_between(400, 600)
    #
    #   # expect(response[:errors].length).to eq 0
    #   # end
    # end

  end
end
