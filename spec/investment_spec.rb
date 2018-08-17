require 'spec_helper'
require 'pp'

describe WealthForge::Investment do

  context 'investment' do

    before do
      WealthForge.configure do |config|
        config.environment = 'ci'
      end
    end

    it "create NEW investment" do

      # basic request with
      # new required fields firstName, lastName
      # fields required fields not given will be filled with default data taken from investor
      old_json_investment_entity = JSON['{
        "investor": {
           "address":"24 Snoshu",
           "name":"Dino LLC",
           "firstName":"David",
           "lastName":"Smith",
           "state":"AK",
           "city":"Anchorage",
           "zip":"90001",
           "email":"dino.simone+alaska@lexshares.com",
           "investorType": "ENTITY",
           "investorSubType": "OTHER",
           "accreditation": "INCOME",
           "phone":"1231231212",
           "dob":"1980-01-01",
           "taxId":"000-00-0000",
           "status":"INVESTOR_ACTIVE"
        },
        "account": {
            "name":"Kelly Tester07",
            "routing":"123456789",
            "number":"12431424"
          },
        "investAmount": 75000,
        "amount": 75000,
        "offerDetail": "179a984f-24c5-4ee9-a230-c2d4ca6f597a",
        "offeringName": "ACB LLC",
        "status": "INVESTMENT_PENDING",
        "paymentType": "ACH"
      }']
    
      # entity with all FundingMethod properties
      # note with entity only the name of entity is set
      old_json_investment_entity_funding_ach = JSON['{
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
           "phone":"1231231212",
           "dob":"1980-01-01",
           "taxId":"000-00-0000",
           "investmentRisk":null,
           "status":"INVESTOR_ACTIVE"
        },
        "account": {
     
            "name":"Dino LLC",
            "routing":"123456789",
            "number":"12431424",
            "bankAccountType": "CHECKING",
            "bankName": "Bank of Virginia"
          },
        "investAmount": 75000,
        "amount": 75000,
        "offerDetail": "179a984f-24c5-4ee9-a230-c2d4ca6f597a",
        "offeringName": "ACB LLC",
        "status": "INVESTMENT_PENDING",
        "paymentType": "ACH"
      }']

      old_json_investment_entity_funding_wire = JSON['{
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
           "phone":"1231231212",
           "dob":"1980-01-01",
           "taxId":"000-00-0000",
           "investmentRisk":null,
           "status":"INVESTOR_ACTIVE"
        },
        "investAmount": 75000,
        "amount": 75000,
        "offerDetail": "179a984f-24c5-4ee9-a230-c2d4ca6f597a",
        "offeringName": "ACB LLC",
        "status": "INVESTMENT_PENDING",
        "paymentType": "WIRE"
      }']

      # individual with all FundingMethod properties
      old_json_investment_individual_funding = JSON['{
        "investor": {
           "address":"24 Snoshu",
           "address2":"suite 221",
           "firstName":"David",
           "lastName":"Smith",
           "state":"AK",
           "city":"Anchorage",
           "zip":"90001",
           "email":"dino.simone+alaska@lexshares.com",
           "investorType": "INDIVIDUAL",
           "accreditation": "INCOME",
           "phone":"1231231212",
           "dob":"1980-01-01",
           "taxId":"000-00-0000",
           "investmentRisk":null,
           "status":"INVESTOR_ACTIVE"
        },
        "account": {
            "nacha":"WEB",
            "firstName": "David",
            "lastName": "Smith",
            "routing":"123456789",
            "number":"12431424",
            "bankAccountType": "SAVINGS",
            "bankName": "Bank of Virginia"
          },
        "investAmount": 75000,
        "amount": 75000,
        "offerDetail": "179a984f-24c5-4ee9-a230-c2d4ca6f597a",
        "offeringName": "ACB LLC",
        "status": "INVESTMENT_PENDING",
        "paymentType": "ACH"
      }']

      # Request with Signatory information
      old_json_investment_signatory = JSON['{
        "investor": {
           "address":"24 Snoshu",
           "name":"Dino LLC",
           "state":"AK",
           "city":"Anchorage",
           "zip":"90001",
           "email":"dino.simone+alaska@lexshares.com",
           "investorType": "ENTITY",
           "investorSubType": "OTHER",
           "accreditation": "INCOME",
           "phone":"1231231212",
           "dob":"1980-01-01",
           "taxId":"000-00-0000",
           "investmentRisk":null,
           "status":"INVESTOR_ACTIVE",
           "signatory": {
              "title": "signatory title",
              "city": "Riverhead",
              "address": "99 River Rd",
              "address2": "Unit A",
              "state": "VA",
              "zip": "22152",
              "firstName": "Donna",
              "lastName": "Roberts",
              "dob":"1980-01-01",
              "signatoryAuthority": true,
              "taxId": "11-222-3333"
            }
          },
          "account": {
              "nacha":"WEB",
              "name":"Kelly Tester07",
              "routing":"123456789",
              "number":"12431424"
            },
          "investAmount": 75000,
          "amount": 75000,
          "offerDetail": "179a984f-24c5-4ee9-a230-c2d4ca6f597a",
          "offeringName": "ACB LLC",
          "status": "INVESTMENT_PENDING",
          "paymentType": "ACH",
          "stash": {
            "field1":"field1",
            "field2":"field2"
          },
          "suitabilityQuestion":[{
            "answerKeys":[
              "b"
          ],
          "questionKey":"Experience"
          }]
        }']

      
        old_json_investment_suitability = JSON['{
          "investor": {
             "address":"24 Snoshu",
             "name":"Dino LLC",
             "firstName":"David",
             "lastName":"Smith",
             "state":"AK",
             "city":"Anchorage",
             "zip":"90001",
             "email":"dino.simone+alaska@lexshares.com",
             "investorType": "ENTITY",
             "investorSubType": "OTHER",
             "accreditation": "INCOME",
             "phone":"1231231212",
             "dob":"1980-01-01",
             "taxId":"000-00-0000",
             "status":"INVESTOR_ACTIVE"
          },
          "account": {
              "name":"Kelly Tester07",
              "routing":"123456789",
              "number":"12431424"
            },
          "investAmount": 75000,
          "amount": 75000,
          "offerDetail": "179a984f-24c5-4ee9-a230-c2d4ca6f597a",
          "offeringName": "ACB LLC",
          "status": "INVESTMENT_PENDING",
          "paymentType": "ACH",
          "suitabilityQuestion":[  
            {  
               "answerKeys":["a"],
               "questionKey":"Experience"
            },
            {  
               "answerKeys":["b"],
               "questionKey":"Objective"
            },
            {  
               "answerKeys":["c"],
               "questionKey":"Tolerance"
            },
            {  
               "answerKeys":[  
                  "a",
                  "b",
                  "d"
               ],
               "questionKey":"Other Investments"
            }
         ]
        }']
      
      response = WealthForge::Investment.create old_json_investment_entity
      pp response
      expect(response['errors']).to eq nil

      # example with suitability and stash
      response = WealthForge::Investment.create old_json_investment_signatory
      pp response
      expect(response['errors']).to eq nil

      response = WealthForge::Investment.create old_json_investment_individual_funding
      pp response
      expect(response['errors']).to eq nil

      response = WealthForge::Investment.create old_json_investment_entity_funding_ach
      pp response
      expect(response['errors']).to eq nil

      response = WealthForge::Investment.create old_json_investment_entity_funding_wire
      pp response
      expect(response['errors']).to eq nil

      response = WealthForge::Investment.create old_json_investment_suitability
      pp response
      expect(response['errors']).to eq nil

      # response = WealthForge::Investment.cancel_subscription "4d2ba9c2-345e-4b43-b21c-ccd351d8712d"
      # expect(response).to eq nil

      # # Get Investment by ID
      # subscription_id = "3e9e7dc1-ad81-4638-ae32-9276b38ac845"
      # response = WealthForge::Investment.get subscription_id
      # pp response
      # expect(response['errors']).to eq nil


      # example of error response 
      # subscription_id = "00000000-0000-0000-0000-000000000000"
      # response = WealthForge::Investment.get subscription_id
      # pp "example of error response"
      # pp response
      # expect(response['errors']).to eq nil

      # file = "#{Dir.pwd}/spec/files/test_file.pdf"
      # subscription_id = "4d2ba9c2-345e-4b43-b21c-ccd351d8712d"
      # response = WealthForge::Investment.file_upload file, subscription_id
      # pp response
      # expect(response['errors']).to eq nil

    end


  # Doc upload
  #   it "create subscription agreement" do
  #     # params = {
  #     #   file: open("#{Dir.pwd}/spec/files/test_file.pdf") 
  #     #   {|f| f.read},
	#     #   filename: "new-file.pdf",
  #     #   remote_investment: @investment_id,
	#     #   parent: "d8cd4024-46aa-4858-9ff1-b10961ec6186",
  #     # }
  #     response = WealthForge::Investment.file_upload
  #     # VCR.use_cassette 'create_subscription_agreement', record: :none do
  #       # response = WealthForge::Investment.create_subscription_agreement @investment_id, params expect(response[:data][:status][:code]).to eq "FILE_INPROGRESS"
  #     # end
  #   end
  # end
  end
end
