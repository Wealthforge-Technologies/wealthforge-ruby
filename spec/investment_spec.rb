require 'spec_helper'
require 'pp'

describe WealthForge::Investment do

  context 'investment' do

    before do
      @investment_id = "d8cd4024-46aa-4858-9ff1-b10961ec6186"
      WealthForge.configure do |config|
        config.environment = 'ci'
      end
    end

    it "create NEW investment" do

      old_json_investment = JSON['{
        "investor": {
           "address":"24 Snoshu",
           "name":"Dino LLC",
           "firstName":"Dino",
           "lastName":"Simone",
           "state":"AK",
           "city":"Anchorage",
           "zip":"90001",
           "email":"dino.simone+alaska@lexshares.com",
           "investorType": "ENTITY",
           "investorSubType": "OTHER",
           "accreditation": "INCOME",
           "phone":"123-123-1212",
           "dob":"1980-01-01",
           "taxId":"000-00-0000",
           "investmentRisk":null,
           "status":"INVESTOR_ACTIVE"
        },
        "account": {
            "nacha":"WEB",
            "name":"Kelly Tester07",
            "routing":"123456789",
            "number":"12431424"
          },
        "investAmount": 75000,
        "amount": 75000,
        "offerDetail": "62eb0e80-8421-4344-9de2-ac69cfeedd1b",
        "offeringName": "test offering name",
        "status": "INVESTMENT_PENDING",
        "paymentType": "ACH"
      }']

      response = WealthForge::Investment.create old_json_investment
      pp JSON.parse response.env.body
      expect(response.status).not_to be_between(400, 600)
    end


   #  it "get investment by id" do
   #    VCR.use_cassette 'get_investment_by_id', record: :none do
   #    	response = WealthForge::Investment.get @investment_id
   #    	expect(response[:errors].length).to eq 0
   #    end
   #  end
  #
  #

#   Doc upload
  #   it "create subscription agreement" do
  #     params = {
  #       file: open("#{Dir.pwd}/spec/files/test_file.pdf") {|f| f.read},
	# filename: "new-file.pdf",
  #       remote_investment: @investment_id,
	# parent: "d8cd4024-46aa-4858-9ff1-b10961ec6186",

  #     }
  #     VCR.use_cassette 'create_subscription_agreement', record: :none do
  #       response = WealthForge::Investment.create_subscription_agreement @investment_id, params
	# expect(response[:data][:status][:code]).to eq "FILE_INPROGRESS"
  #     end
  #   end
  

  end




end
