require 'json'
require './enums'
require 'pp'


# TODO: 'investor' will be a stash ID that has that info

old_json = JSON['{
  "investor": "524fcabb-a122-428f-bc20-1247cf87c1b3",
  "account": null,
  "investAmount": 75000,
  "amount": 75000,
  "offerDetail": "62eb0e80-8421-4344-9de2-ac69cfeedd1b",
  "status": "INVESTMENT_PENDING",
  "paymentType": "WIRE"
}']



new_json = {
    data: {
        attributes: {
            investor: old_json['investor'],   # TODO-rename
            investmentAmount: old_json['amount'], # use amount instead of investAmount because if the price != 1 then investAmount will change TODO-rename
            paymentMethod: old_json['paymentType'], # TODO-rename
            TODOstatus: Enums::investment_status_enum[''] # note: we do not change the status in capforge!
        },
        type: 'subscriptions'
    }
}

pp new_json



case old_json['data']['investor']['accreditation']['code']
  when 'INCOME'
    if old_json['data']['investor']['investorType']['code'] == 'INDIVIDUAL'
      new_json['data']['attributes']['accreditationType'] = 'INDIVIDUAL_INCOME'
    end
    if old_json['data']['investor']['investorType']['code'] == 'MARRIED'
      new_json['data']['attributes']['accreditationType'] = 'MARRIED_INCOME'
    end
  else
    new_json['data']['attributes']['accreditationType'] = Enums::investor_accreditation_enum.find{|key, hash| hash[0] == oldaccr}[0].to_s
end

# =======================================================================================================================================
# =======================================================================================================================================
# =======================================================================================================================================
# =======================================================================================================================================

# enums are new => old



old_json = {
"data": {
    "id": "7c3ebefb-2f49-4ba6-b39f-be137e848b37",
    "offerDetail": "62eb0e80-8421-4344-9de2-ac69cfeedd1b",
    "subscriptionAgreementStatus": nil,
    "paymentStatus": nil,
    "status": {
        "code": "INVESTMENT_PENDING", # todo: map -- COMPLEX
        "name": "Pending", # todo: map
        "metadata": nil,
        "sequence": nil,
        "active": nil,
        "updatedAt": 1387360913297,
        "hidden": nil
    },
    "escrowStatus": nil,
    "paymentType": {
        "code": "WIRE", #new_json['paymentMethodRENAME']
        "name": "Wire", #payment_code_name_enum[new_json['paymentMethodRENAME']]
        "metadata": nil,
        "sequence": 4,
        "active": nil,
        "updatedAt": 1412771282248,
        "hidden": nil
    },
    "account": nil,
    "investor": {
        "id": "524fcabb-a122-428f-bc20-1247cf87c1b3",
        "investmentTimeline": {
            "code": nil,
            "name": nil
        },
        "country": nil,
        "state": {
            "code": "AL", #TODO - easy
            "name":  Enums::state_code_enum[new_json['____TODO____']],
            "hidden": false
        },
        "accreditation": {
            "code": Enums::investor_accreditation_enum['__TODO__'][0]
            "name": Enums::investor_accreditation_enum['__TODO__'][1]
            "metadata": nil,
            "sequence": 2,
            "active": true,
            "version": "2.0",
            "updatedAt": 1450899477335, #TODO
            "hidden": false
        },
        "investmentRisk": {
            "code": nil,
            "name": nil
        },
        "investorType": {
            "code": "INDIVIDUAL",  #TODO: map
            "name": "Individual",  #TODO: map
            "metadata": nil,
            "sequence": nil,
            "active": true,
            "updatedAt": 1389792976423,
            "hidden": false
        },
        "investorSubType": nil,
        "status": {
            "code": "INVESTOR_ACTIVE", #TODO: not sure if we have this
            "name": "Active",
            "metadata": nil,
            "sequence": 2,
            "active": nil,
            "updatedAt": 1387360828185,
            "hidden": nil
        },
        "name": "adf sadfa", #TODO - easy
        "logo": "http://none", #???
        "city": "adf", #TODO - easy
        "investorUrl": "http://none", #???
        "address": "adf",  #TODO - easy
        "address2": nil,  #TODO - easy
        "phone": "123-123-1212",  #TODO -- same format???
        "zip": "10213", #TODO - easy
        "signature": nil, #probably not in new
        "taxId": nil, #TODO - easy maybe
        "uid": nil, #??
        "accredited": true, #??
        "dob": 410245200000, #TODO - convert date
        "income": nil,
        "netWorth": nil,
        "accreditedOther": nil,
        "eligibleInvestAmount": nil,
        "email": "dino.simone+cabinman@lexshares.com", #TODO - easy
        "purchaseRepExists": false,
        "purchaseRepName": nil,
        "purchaseRepAddress": nil,
        "purchaseRepAddress2": nil,
        "purchaseRepCity": nil,
        "purchaseRepState": nil,
        "purchaseRepZip": nil,
        "existingRelationship": nil,
        "existingRelationshipName": nil,
        "existingRelationshipYears": nil,
        "existingRelationshipNature": nil,
        "yearVerified": nil,
        "accreditationFile": nil,
        "ssn": "123-12-1211" #todo: easy
    },
    "wfStatus": nil, #lex should always be expecting null because we never change the statuses in capforge
    "dateStart": nil,
    "dateEnd": nil,  #what is date end of an investment?
    "investAmount": 75000,
    "expectedReturn": nil, #???
    "percentageOwnership": nil, #not in new
    "inMinRaiseAchieved": nil,
    "uuidCertificate": nil, #???
    "amount": 75000
}
}

