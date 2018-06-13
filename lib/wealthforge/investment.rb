require 'base64'
require 'mime/types'
require 'json'


class WealthForge::Investment


  def self.create(params)
    WealthForge::Connection.post "subscriptions", old_to_new_create(params)
  end


  # lexshares will sometimes use this GET
  def self.get(investment_id)
    WealthForge::Connection.get "investment/#{investment_id}", nil
  end


  def self.create_subscription_agreement(investment_id, params)
    # todo: obie says we will probably just ask for the file. check with dino if thats ok or if they need these fields
    mapped_params = {
        status: {code: 'FILE_INPROGRESS', active: true},
        mimeType: MIME::Types.type_for(params[:filename]).first.to_s,
        folder: {parentFolder: {code: 'DUE_DILIGENCE'}},
        fileName: params[:filename],
        displayTitle: params[:filename],
        content: Base64.strict_encode64(params[:file]),
        parent: params[:parent]
    }

    WealthForge::Connection.put "investment/#{investment_id}/subscriptionAgreement", mapped_params
  end

end

private

def old_to_new_create_subscription(old_json)
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
    if old_json['investor']['signatory'] != nil
        new_json[:data][:attributes][:investors][0][:signatory][:title] = old_json['investor']['signatory']['title'] #TODO: not in old flow -- default or is it not required
        new_json[:data][:attributes][:investors][0][:signatory][:address][:city] = old_json['investor']['signatory']['city']
        new_json[:data][:attributes][:investors][0][:signatory][:address][:street1] = old_json['investor']['signatory']['address']
        new_json[:data][:attributes][:investors][0][:signatory][:address][:stateProv] = old_json['investor']['signatory']['state']
        new_json[:data][:attributes][:investors][0][:signatory][:address][:postalCode] = old_json['investor']['signatory']['zip']
        new_json[:data][:attributes][:investors][0][:signatory][:dateOfBirth] = old_json['investor']['signatory']['dob']
        new_json[:data][:attributes][:investors][0][:signatory][:lastName] = old_json['investor']['signatory']['lastName']
        new_json[:data][:attributes][:investors][0][:signatory][:firstName] = old_json['investor']['signatory']['firstName']
        new_json[:data][:attributes][:investors][0][:signatory][:signatoryAuthority] = old_json['investor']['signatory']['signatoryAuthority'] #TODO: is this in old flow?
        new_json[:data][:attributes][:investors][0][:signatory][:ssn] = old_json['investor']['signatory']['taxId'] #TODO:
    else
        # new_json['data']['attributes']['investors'][0]['signatory']['title'] = old_json['investor'] #TODO: not in old flow -- default or is it not required
        # new_json['data']['attributes']['investors'][0]['signatory']['address']['city'] = old_json['investor']['city']
        # new_json['data']['attributes']['investors'][0]['signatory']['address']['street1'] = old_json['investor']['address']
        # new_json['data']['attributes']['investors'][0]['signatory']['address']['stateProv'] = old_json['investor']['state']
        # new_json['data']['attributes']['investors'][0]['signatory']['address']['postalCode'] = old_json['investor']['zip']
        # new_json['data']['attributes']['investors'][0]['signatory']['dateOfBirth'] = old_json['investor']['dob']
        # new_json['data']['attributes']['investors'][0]['signatory']['lastName'] = old_json['investor']['']
        # new_json['data']['attributes']['investors'][0]['signatory']['firstName'] = old_json['investor']['']
        # new_json['data']['attributes']['investors'][0]['signatory']['signatoryAuthority'] = old_json['investor'][''] #TODO: is this in old flow?
        # new_json['data']['attributes']['investors'][0]['signatory']['ssn'] = old_json['investor'][''] #TODO:
    end
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

    #fill with default value if not given
    if old_json['account']['bankAccountType'] != nil
        new_json[:data][:attributes][:fundingMethods][0][:accountType] = old_json['account']['bankAccountType']
    else
        new_json[:data][:attributes][:fundingMethods][0][:accountType] = 'Checking' #TODO: api has a nacha object that has this info but idk where it is in the normal call
    end
    
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
return new_json
end




# ========================
# ==== helper methods ====
# ========================