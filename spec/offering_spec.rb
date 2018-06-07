require 'spec_helper'
require 'pp'

describe WealthForge::Offering do

  context 'offering' do

    before do
      @offering_id = "3d609eb4-93aa-444c-be02-72ee5ec584ad"
      WealthForge.configure do |config|
        config.environment = 'local'
      end
    end


    it "create OLD offering" do

      old_json = JSON['{
        "issuer":"857355020872",
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
                "regulationType":"MEMO_EQUITY_D506C"
            }
        ],
        "status":"OFFERING_PENDING",
        "dateStart":"2019-03-05",
        "dateEnd":"2020-05-06"
      }']



      # VCR.use_cassette 'create_offering', record: :none do
      response = WealthForge::Offering.create old_json
      # pp JSON.parse response.env.body
      expect(response.status).not_to be_between(400, 600)
      # end
    end



    # it "create NEW offering" do
    #
    #   new_json = {
    #     data: {
    #       attributes: {
    #           issuerID: '495e756f-e77f-4bbe-a4ee-68405640542b',
    #           status: 'PENDING_REVIEW',
    #         title: 'new offering from middleware',
    #         offeringType: 'REG_D_506_C',
    #         startDate: '2019-03-05',
    #         endDate: '2020-03-05',
    #         minimumRaise: '1900000',
    #         maximumRaise: '2000000',
    #         minimumInvestment: '50000',
    #         paymentMethods: ['ACH','WIRE'],
    #         securityTypes: [{
    #           type: 'COMMON_STOCK',
    #           securityPrice: '23.33',
    #           numSharesOffered: 10_000,
    #         }]
    #       },
    #       type: 'offerings'
    #     }
    #   }
    #
    #   # VCR.use_cassette 'create_offering', record: :none do
    #   response = WealthForge::Offering.create new_json
    #   # pp JSON.parse response.env.body
    #   expect(response.status).not_to be_between(400, 600)
    #   # end
    # end


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
