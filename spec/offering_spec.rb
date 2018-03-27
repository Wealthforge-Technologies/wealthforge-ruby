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


    it "create offering" do

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

      params = old_to_new_create(old_json)


      # VCR.use_cassette 'create_offering', record: :none do
      response = WealthForge::Offering.create params
      pp JSON.parse response.env.body
      expect(response.status).not_to be_between(400, 600)
      # end
    end

    # TODO: list of offerings
    # it "get list of offerings" do
    #   VCR.use_cassette 'list_offerings', record: :none do
    #     response = WealthForge::Offering.all
    #     puts response.inspect
    #     expect(response[:errors].length).to eq 0
    #   end
    # end


    it "get offering" do
      # VCR.use_cassette 'get_offering_by_id', record: :none do
      response = WealthForge::Offering.get 'cf99116c-1209-47a7-a52a-46332ed7245f'
      pp JSON.parse response.env.body
      expect(response.status).not_to be_between(400, 600)

      # expect(response[:errors].length).to eq 0
      # end
    end

  end


  # ========================
  # ==== helper methods ====
  # ========================


  def old_to_new_create(old_json)

    offering_type_enum = {
        'REG_D_506_B': 'MEMO_EQUITY_D506B',
        'REG_D_506_C': 'MEMO_EQUITY_D506C'
    }

    new_json = {
      data: {
        attributes: {
          title: 'aadddd',   #TODO: title?????
          offeringType: offering_type_enum.key(old_json['offerDetails'][0]['regulationType']),
          startDate: old_json['dateStart'],
          endDate: old_json['dateEnd'],
          minimumRaise: old_json['minRaise'].to_s,
          maximumRaise: old_json['maxRaise'].to_s,
          minimumInvestment: old_json['offerDetails'][0]['minInvestment'].to_s,
          paymentMethod: 'ACH', # <hardcoded>
          securityTypes: [{
            type: '',
          }],
        },
      type: 'offerings'
    }
    }

    case old_json['offerDetails'][0]['instrumentType']
      when 'SHARE_COMMON'
        new_json[:data][:attributes][:securityTypes][0][:type] = 'COMMON_STOCK'
        new_json[:data][:attributes][:securityTypes][0][:securityPrice] = old_json['offerDetails'][0]['price'].to_s
        new_json[:data][:attributes][:securityTypes][0][:numSharesOffered] = old_json['totalShare'].to_i
      else
        raise '__PARSING ERROR__  INVALID / UNMAPPED offerDetailType from capForge request offering/create!'
    end

    return new_json

  end


end
