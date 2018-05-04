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


    # it "get all investments" do
    #   # VCR.use_cassette 'get_investments', record: :none do
    #     response = WealthForge::Investment.all
    #     # expect(response[:data].size).to be > 0
    #     # expect(response[:errors].length).to eq 0
    #     pp response
    #   # end
    # end


    it "create NEW investment" do

      old_json = JSON['{
          "investor": "524fcabb-a122-428f-bc20-1247cf87c1b3",
          "account": null,
          "investAmount": 75000,
          "amount": 75000,
          "offerDetail": "62eb0e80-8421-4344-9de2-ac69cfeedd1b",
          "status": "INVESTMENT_PENDING",
          "paymentType": "WIRE"
      }']

      response = WealthForge::Investment.create old_json
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
   #  it "update investment" do
   #    VCR.use_cassette 'update_investment', record: :none do
   #      investment    = {amount: 7500}
   #      response = WealthForge::Investment.update(@investment_id, investment)
   #      expect(response[:errors].length).to eq 0
   #      expect(response[:data][:amount]).to eq 7500
   #    end
   #  end
  #
  #
   #  it "get redirect URL" do
   #    VCR.use_cassette 'investment_status', record: :none do
   #      response = WealthForge::Investment.redirect_url @investment_id
   #      expect(response[:errors].length).to eq 0
   #      expect(response[:data]).to match /capitalforge-transaction/
   #    end
   #  end
  #
  #
   #  it "get status" do
   #    VCR.use_cassette 'investment_status', record: :none do
   #      response = WealthForge::Investment.status @investment_id
   #      expect(response[:errors].length).to eq 0
   #      expect(response[:data][:code]).to eq "INVESTMENT_APPROVED"
   #    end
   #  end
  #
  #
   #  it "get investment account" do
   #    VCR.use_cassette 'investment_account', record: :none do
   #      response = WealthForge::Investment.account @investment_id
   #      expect(response[:errors].length).to eq 0
   #    end
   #  end
  #
   #
   #  it "update investment account" do
   #    account = {
   #     name:      "John Smith",
   #     parent_id:  "7025856b-0d20-4bfa-a92f-c433793c7883",
   #     routing:   "011103093",
   #     number:    "1234567",
   #     id:        "044bac29-96aa-4208-9a46-bf865b0817db"
   #    }
   #    VCR.use_cassette 'update_investment_account', record: :none do
   #      response = WealthForge::Investment.update_account @investment_id, account
   #      expect(response[:errors].length).to eq 0
   #      expect(response[:data][:nacha][:code]).to eq "CCD"
   #    end
   #  end
  #
  #
   #  it "request investment approval" do
   #    VCR.use_cassette 'request_investment_approval', record: :none do
   #      response = WealthForge::Investment.approve @investment_id
   #      expect(response[:errors].length).to eq 0
   #      expect(response[:data][:status][:code]).to eq "INVESTMENT_APPROVED"
   #    end
   #  end
  #
  #
   #  it "request subscription approval" do
   #    VCR.use_cassette 'request_subscription_approval', record: :none do
   #      response = WealthForge::Investment.approve_subscription @investment_id
   #      expect(response[:errors].length).to eq 0
   #      expect(response[:data][:subscriptionAgreementStatus][:code]).to eq "SA_APPROVED"
   #    end
   #  end
  #
  #
   #  it "gets due diligence" do
   #    skip "Not working"
   #    VCR.use_cassette 'due_dilegence', record: :none do
   #      response = WealthForge::Investment.due_diligence @investment_id
   #      expect(response[:data]).to eq nil
   #    end
   #  end
  #
  #
   #  it "create subscription agreement" do
   #    params = {
   #      file: open("#{Dir.pwd}/spec/files/test_file.pdf") {|f| f.read},
	# filename: "new-file.pdf",
   #      remote_investment: @investment_id,
	# parent: "d8cd4024-46aa-4858-9ff1-b10961ec6186",
  #
   #    }
   #    VCR.use_cassette 'create_subscription_agreement', record: :none do
   #      response = WealthForge::Investment.create_subscription_agreement @investment_id, params
	# expect(response[:data][:status][:code]).to eq "FILE_INPROGRESS"
   #    end
   #  end
  #
  #
   #  it "gets certificate" do
   #    skip "Should return fileApiObject; API call is broken"
   #  end
  #
  #
   #  it "gets due diligence file" do
   #    skip "Not implemented"
   #  end
  #
  #
   #  it "gets subscription agreement" do
   #    skip "Not implemented"
   #  end
  #
   #
   #  it "get term sheets" do
   #    skip "Not implemented"
   #  end

  end




end
