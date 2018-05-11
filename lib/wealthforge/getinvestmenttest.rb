require 'json'
require './enums'
require 'pp'

old_json = JSON['{

  "investor": {
     "address":"24 Snoshu",
     "name":"Dino Simone",
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
  }
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
  "paymentType": "WIRE"
}']

#TODO: map entity

# NOTE: Married / Joint did not exist in gen 1

new_json = {
    data: {
        attributes: {
            fundingMethods: [
                {
                    accountFirstName: old_json['investor']['firstName'], # Note: same as investor name
                    accountLastName: old_json['investor']['lastName'],  # Note: same as investor name
                    accountNumber: old_json['account']['number'], #TODO: get from different example, it is null
                    accountType: "CHECKING", #TODO: api has a nacha object that has this info but idk where it is in the normal call
                    bankName: "Crestar", #TODO: ?????? not in gen1
                    investmentAmount: old_json['amount'], # use amount instead of investAmount because if the price != 1 then investAmount will change
                    paymentType: Enums::payment_type_enum(old_json['paymentType']),
                    routingNumber: old_json['account']['routing']
                }
            ],
            investors: [
                {
                    accreditationType: '', # defined below
                    address: {
                        city: old_json['investor']['city'],
                        country: "USA", # hardcoded
                        postalCode: old_json['investor']['zip'],
                        stateProv: old_json['investor']['state'],
                        street1: old_json['investor']['address'],
                        street2: '' # not in gen1
                    },
                    investorType: old_json['investor']['investorType'],
                    primaryPhone: old_json['investor']['phone'],
                    ssn: old_json['investor']['taxId'] # this is ein or ssn depending on investor type
                }
            ],
        },
        type: "subscription"
    }
}



if old_json['data']['investor']['investorType'] == 'ENTITY'
  #todo entity stuff
  new_json['data']['attributes']['investors'][0]['entityType'] = old_json['data']['investor']['entityType'] #todo - not sure of this is correct for old json


elsif old_json['data']['investor']['investorType'] == 'INDIVIDUAL'
  #todo move individual stuff here
  #
  new_json['data']['attributes']['investors'][0]['dateOfBirth'] = old_json['investor']['dob'],
      new_json['data']['attributes']['investors'][0]['firstName'] = old_json['investor']['firstName']
  new_json['data']['attributes']['investors'][0]['lastName'] = old_json['investor']['lastName']

  "isFINRA": true,
  "signatory": {
      "title": "CFO",
      "address": {
          "city": "Richmond",
          "street1": "PO Box 249",
          "street2": "Suite 200",
          "stateProv": "VA",
          "postalCode": "23226",
          "country": "USA"
      },
      "dateOfBirth": "1970-02-28",
      "lastName": "Beck",
      "firstName": "Stacy",
      "signatoryAuthority": true,
      "ssn": "987654321"
  },
      "ein": "abcdefghi",

end


      pp new_json



case old_json['data']['investor']['accreditation']['code']
  when 'INCOME'
    if old_json['data']['investor']['investorType']['code'] == 'INDIVIDUAL'
      new_json['data']['attributes']['investors'][0]['accreditationType'] = 'INDIVIDUAL_INCOME'
    end
    if old_json['data']['investor']['investorType']['code'] == 'MARRIED'
      new_json['data']['attributes']['investors'][0]['accreditationType'] = 'MARRIED_INCOME'
    end
  else
    new_json['data']['attributes']['investors'][0]['accreditationType'] = Enums::investor_accreditation_enum.find{|key, hash| hash[0] == oldaccr}[0].to_s
end

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

