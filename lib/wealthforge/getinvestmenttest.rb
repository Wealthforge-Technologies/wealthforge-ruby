require 'json'
require_relative './enums'
require 'pp'


old_json = JSON['{
  "investor": {
     "address":"24 Snoshu",
     "name":"Dino Simone",
     "firstName":"Dino",
     "lastName":"Simone",
     "state":"AK",
     "city":"Anchorage",
     "zip":"90001",
     "email":"dino.simone+alaska@lexshares.com",
     "investorType":"INDIVIDUAL",
     "investorSubType":null,
     "accreditation":"INCOME",
     "accredited":true,
     "phone":"123-123-1212",
     "investmentTimeline":null,
     "dob":"1980-01-01",
     "taxId":"000-00-0000",
     "investmentRisk":null,
     "status":"INVESTOR_ACTIVE",
     "logo":"http://none",
     "investorUrl":"http://none",
     "purchaseRepExists":false
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
  "status": "INVESTMENT_PENDING",
  "paymentType": "ACH"
}']

#TODO: map entity

# NOTE: Married / Joint did not exist in gen 1

new_json = {
    data: {
        attributes: {
            investors: [
                {
                    accreditationType: old_json['investor']['accreditation'],
                    address: {
                        city: old_json['investor']['city'],
                        postalCode: old_json['investor']['zip'],
                        stateProv: old_json['investor']['state'],
                        street1: old_json['investor']['address'],
                        street2: old_json['investor']['address2']
                    },
                    investorType: old_json['investor']['investorType'],
                    primaryPhone: old_json['investor']['phone'],
                    ssn: old_json['investor']['taxId'], # this is ein or ssn depending on investor type
                    email: old_json['investor']['email'],
                    isPrimary: true
                }
            ],
            offering: {
                id: old_json['offeringDetail']
            },
            fundingMethods: [
                {
                    paymentType: old_json['paymentType'],
                    investmentAmount: old_json['amount'],
                    numberOfShares: nil, 
                    numberOfNotes: nil,
                    accountNumber: nil,
                    address:{
                        street1:nil,
                        street2:nil,
                        city:nil,
                        state:nil,
                        country:nil,
                        postalCode:nil,
                    }

                }
            ],
            entityType: old_json['investor']['entityType'],
            investmentAmount: old_json['amount'], # use amount instead of investAmount because if the price != 1 then investAmount will change
        },
        type: "subscription"
    }
}

#  ====== load different investor types ======
#
if old_json['investor']['investorType'] == 'ENTITY'
    #todo entity stuff --- NEED EXAMPLE!!!!!
    new_json[:data][:attributes][:investors][0][:entityType] = old_json['investor']['entityType'] #todo - not sure of this is correct for old json
    new_json[:data][:attributes][:investors][0][:name] = old_json['investor']['name']
    new_json[:data][:attributes][:fundingMethods][0][:accountBusinessName] = old_json['account']['name'] # Note: same as investor name
    
    new_json['data']['attributes']['investors'][0]['signatory']['title'] = old_json['investor'] #TODO: not in old flow -- default or is it not required
    new_json['data']['attributes']['investors'][0]['signatory']['title'] = old_json['investor'] #TODO: not in old flow -- default or is it not required
    new_json['data']['attributes']['investors'][0]['signatory']['address']['city'] = old_json['investor']['city']
    new_json['data']['attributes']['investors'][0]['signatory']['address']['street1'] = old_json['investor']['address']
    new_json['data']['attributes']['investors'][0]['signatory']['address']['stateProv'] = old_json['investor']['state']
    new_json['data']['attributes']['investors'][0]['signatory']['address']['postalCode'] = old_json['investor']['zip']
    new_json['data']['attributes']['investors'][0]['signatory']['dateOfBirth'] = old_json['investor']['dob']
    new_json['data']['attributes']['investors'][0]['signatory']['lastName'] = old_json['investor']['']
    new_json['data']['attributes']['investors'][0]['signatory']['firstName'] = old_json['investor']['']
    new_json['data']['attributes']['investors'][0]['signatory']['signatoryAuthority'] = old_json['investor'][''] #TODO: is this in old flow?
    new_json['data']['attributes']['investors'][0]['signatory']['ssn'] = old_json['investor'][''] #TODO:
elsif old_json['investor']['investorType'] == 'INDIVIDUAL'
   #todo move individual stuff here
    new_json[:data][:attributes][:investors][0][:dateOfBirth] = old_json['investor']['dob']
    new_json[:data][:attributes][:investors][0][:fistName] = old_json['investor']['firstName'] # Note: Dino says he will send the first and last separately because gen1 had them together in 'name'
    new_json[:data][:attributes][:investors][0][:lastName] = old_json['investor']['lastName']
    new_json[:data][:attributes][:investors][0][:ein] = old_json['investor']['taxId'] #TODO:
end

#fill investor address
new_json[:data][:attributes][:investors][0][:address][:street1] = old_json['investor']['address'] #TODO
new_json[:data][:attributes][:investors][0][:address][:city] = old_json['investor']['city']
new_json[:data][:attributes][:investors][0][:address][:stateProv] = old_json['investor']['state']
new_json[:data][:attributes][:investors][0][:address][:postalCode] = old_json['investor']['zip']
new_json[:data][:attributes][:investors][0][:address][:country] = 'USA'

# #  ====== load different payment method types ======
case old_json['paymentType']
  when 'ACH'
    new_json[:data][:attributes][:fundingMethods][0][:accountNumber] = old_json['account']['number'] #TODO: get from different example, it is null
    new_json[:data][:attributes][:fundingMethods][0][:accountType] = 'Checking' #TODO: api has a nacha object that has this info but idk where it is in the normal call
    new_json[:data][:attributes][:fundingMethods][0][:bankName] = old_json['account']['bankName'] #TODO: uncollected by lexshares
    new_json[:data][:attributes][:fundingMethods][0][:routingNumber] = old_json['account']['routing']
    new_json[:data][:attributes][:fundingMethods][0][:accountBusinessName] = old_json['account']['accountBusinessName']
    new_json[:data][:attributes][:fundingMethods][0][:accountBusinessName] = old_json['account']['accountBusinessName']
    new_json[:data][:attributes][:fundingMethods][0][:accountFirstName] = old_json['account']['accountFirstName']
    new_json[:data][:attributes][:fundingMethods][0][:accountLastName] = old_json['account']['accountLastName']

    if old_json['account']['address'] != nil 
        new_json[:data][:attributes][:fundingMethods][0][:address][:street1] = old_json['account']['address']['street1'] #TODO
        new_json[:data][:attributes][:fundingMethods][0][:address][:city] = old_json['account']['address']['city']
        new_json[:data][:attributes][:fundingMethods][0][:address][:stateProv] = old_json['account']['address']['state']
        new_json[:data][:attributes][:fundingMethods][0][:address][:postalCode] = old_json['account']['address']['zip']
        new_json[:data][:attributes][:fundingMethods][0][:address][:country] = 'USA'
    end 

  when 'WIRE'
    # do nothing
  else
    # other payment types are not supported in either generation (no IRA in gen1, no check in gen4)
    #p '--- ERROR: unmapped or invalid payment type in subscription!!'
end


pp new_json

# =======================================================================================================================================
# =======================================================================================================================================
# =======================================================================================================================================
# =======================================================================================================================================


# old_json = {
# "data": {
#     "id": "7c3ebefb-2f49-4ba6-b39f-be137e848b37",
#     "offerDetail": "62eb0e80-8421-4344-9de2-ac69cfeedd1b",
#     "subscriptionAgreementStatus": nil,
#     "paymentStatus": nil,
#     "status": {
#         "code": "INVESTMENT_PENDING", # todo: map -- COMPLEX
#         "name": "Pending", # todo: map
#         "metadata": nil,
#         "sequence": nil,
#         "active": nil,
#         "updatedAt": 1387360913297,
#         "hidden": nil
#     },
#     "escrowStatus": nil,
#     "paymentType": {
#         "code": "WIRE", #new_json['paymentMethodRENAME']
#         "name": "Wire", #payment_code_name_enum[new_json['paymentMethodRENAME']]
#         "metadata": nil,
#         "sequence": 4,
#         "active": nil,
#         "updatedAt": 1412771282248,
#         "hidden": nil
#     },
#     "account": nil,
#     "investor": {
#         "id": "524fcabb-a122-428f-bc20-1247cf87c1b3",
#         "investmentTimeline": {
#             "code": nil,
#             "name": nil
#         },
#         "country": nil,
#         "state": {
#             "code": "AL", #TODO - easy
#             "name":  Enums::state_code_enum[new_json['____TODO____']],
#             "hidden": false
#         },
#         "accreditation": {
#             "code": Enums::investor_accreditation_enum['__TODO__'][0]
#             "name": Enums::investor_accreditation_enum['__TODO__'][1]
#             "metadata": nil,
#             "sequence": 2,
#             "active": true,
#             "version": "2.0",
#             "updatedAt": 1450899477335, #TODO
#             "hidden": false
#         },
#         "investmentRisk": {
#             "code": nil,
#             "name": nil
#         },
#         "investorType": {
#             "code": "INDIVIDUAL",  #TODO: map
#             "name": "Individual",  #TODO: map
#             "metadata": nil,
#             "sequence": nil,
#             "active": true,
#             "updatedAt": 1389792976423,
#             "hidden": false
#         },
#         "investorSubType": nil,
#         "status": {
#             "code": "INVESTOR_ACTIVE", #TODO: not sure if we have this
#             "name": "Active",
#             "metadata": nil,
#             "sequence": 2,
#             "active": nil,
#             "updatedAt": 1387360828185,
#             "hidden": nil
#         },
#         "name": "adf sadfa", #TODO - easy
#         "logo": "http://none", #???
#         "city": "adf", #TODO - easy
#         "investorUrl": "http://none", #???
#         "address": "adf",  #TODO - easy
#         "address2": nil,  #TODO - easy
#         "phone": "123-123-1212",  #TODO -- same format???
#         "zip": "10213", #TODO - easy
#         "signature": nil, #probably not in new
#         "taxId": nil, #TODO - easy maybe
#         "uid": nil, #??
#         "accredited": true, #??
#         "dob": 410245200000, #TODO - convert date
#         "income": nil,
#         "netWorth": nil,
#         "accreditedOther": nil,
#         "eligibleInvestAmount": nil,
#         "email": "dino.simone+cabinman@lexshares.com", #TODO - easy
#         "purchaseRepExists": false,
#         "purchaseRepName": nil,
#         "purchaseRepAddress": nil,
#         "purchaseRepAddress2": nil,
#         "purchaseRepCity": nil,
#         "purchaseRepState": nil,
#         "purchaseRepZip": nil,
#         "existingRelationship": nil,
#         "existingRelationshipName": nil,
#         "existingRelationshipYears": nil,
#         "existingRelationshipNature": nil,
#         "yearVerified": nil,
#         "accreditationFile": nil,
#         "ssn": "123-12-1211" #todo: easy
#     },
#     "wfStatus": nil, #lex should always be expecting null because we never change the statuses in capforge
#     "dateStart": nil,
#     "dateEnd": nil,  #what is date end of an investment?
#     "investAmount": 75000,
#     "expectedReturn": nil, #???
#     "percentageOwnership": nil, #not in new
#     "inMinRaiseAchieved": nil,
#     "uuidCertificate": nil, #???
#     "amount": 75000
# }
# }

