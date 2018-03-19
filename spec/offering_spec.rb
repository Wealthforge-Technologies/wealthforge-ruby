require "spec_helper"

describe WealthForge::Offering do

  context 'offering' do

    before do
      @offering_id = "3d609eb4-93aa-444c-be02-72ee5ec584ad"
      WealthForge.configure do |config|
        config.environment = 'ci'
      end
    end


    it "create offering" do

      params = {
        data: {
          attributes: {
            title: 'title 11',
            offeringType: 'REG_D_506_B',
            startDate: '2008-01-02',
            endDate: '2008-01-03',
            minimumRaise: '27.00',
            maximumRaise: '27.01',
            minimumInvestment: '123333', # 500 error when missing
            paymentMethod: 'ACH',
            classTitle: 'RCP debt loan terms (3 yr, 4 yr, 5 yr)',
            securityTypes: [
              {
                type: 'DEBT',  # 500 error when missing
                securityPrice: '1500653.29', # 500 error when missing
                interestRate: '0.059', # 500 error when missing
                numMonthsToMaturity: 73, # 500 error when missing
                numNotesOffered: 1010, # 500 error when missing
                distributionFrequency: 'MONTHLY' # 500 error when missing
              }
            ]
          },
          type: 'offerings'
        }
      }

      # VCR.use_cassette 'create_offering', record: :none do
        response = WealthForge::Offering.create params
        expect(response.status).not_to be_between(400, 600)
      # end
    end


    # it "get list of offerings" do
    #   VCR.use_cassette 'list_offerings', record: :none do
    #     response = WealthForge::Offering.all
    #     puts response.inspect
    #     expect(response[:errors].length).to eq 0
    #   end
    # end
    #
    # it "get offering" do
    #   VCR.use_cassette 'get_offering_by_id', record: :none do
    #     response = WealthForge::Offering.get @offering_id
    #     expect(response[:errors].length).to eq 0
    #   end
    # end

    #
    # it "update offering" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "get redirect URL" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "get offering status" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "get offering account" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "update offering account" do
    #   skip "Not yet implemented"
    # end
    #
    # it "request offering approval" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "offering due diligence file" do
    #   skip "Not yet implemented"
    # end
    #
    # it "offering due diligence folder" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "create offering escrow" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "update offering escrow" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "offering investments" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "offering details" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "update offering detail" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "offering list of memos" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "create/replace offering memo" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "offering placement agreement" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "create/replace offering placement agreement" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "get offering tri-party escrow" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "create/replace offering escrow agreement" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "get offering w-9" do
    #   skip "Not yet implemented"
    # end
    #
    #
    # it "create/replace offering w-9" do
    #   skip "Not yet implemented"
    # end


  end

end
