require 'base64'
require 'mime/types'
require 'json'
require 'ostruct'


class WealthForge::Investment
  def self.create(params = {})
    newjson = old_to_new_create(params)
    pp "New Request Is :"
    pp newjson
    WealthForge::Connection.post "subscriptions", newjson
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


def setTaxId (taxId)
    id = nil
    if taxId != nil 
        id = taxId.gsub("-", "")
    end
    return id
end

def ConvertToJson(object)
    newRequest = {}
    object.each_pair do |key, value|
        newRequest[key] = case value
        when OpenStruct then ConvertToJson(value)
        when Array then value.map { |v| ConvertToJson(v) }
            else value
        end
    end
    return newRequest
end

private
def old_to_new_create(old_json)
    
    newJ = {
        data: {
            attributes: {
                investors: [
                    {
                        accreditationType: nil,
                        address: {
                            city: nil,
                            country: nil,
                            postalCode: nil,
                            stateProv: nil,
                            street1: nil,
                            street2: nil
                        },
                        crdNumber: nil,
                        dateOfBirth: nil,
                        emailAddress: nil,
                        firstName: nil,
                        investorType: nil,
                        isPrimary: nil,
                        lastName: nil,
                        name: nil,
                        primaryPhone: nil,
                        ssn: nil,
                        ein: nil,                        
                        signatory: {
                            title: nil,
                            address: {
                                city: nil,
                                street1: nil,
                                street2: nil,
                                stateProv: nil,
                                postalCode: nil, 
                                country: nil
                            },
                            dataOfBirth: nil,
                            lastName: nil,
                            fistName: nil,
                            signatoryAuthority: nil,
                            taxId: nil 
                        }
                    }
                ],
                fundingMethods: [
                    {
                        accountFirstName: nil,
                        accountLastName: nil,
                        accountNumber: nil,
                        accountType:nil,
                        bankName: nil,
                        routingNumber: nil,
                        address:{
                            street1:nil,
                            street2:nil,
                            city:nil,
                            state:nil,
                            country:nil,
                            postalCode:nil
                        }, 
                        investmentAmount: nil,
                        numberOfShares: nil, 
                        numberOfNotes: nil,
                        paymentType: nil
                    }
                ],
                investmentAmount: nil,
                offering: {
                    id: nil, # old_json['offeringDetail']
                    name: nil, # old_json['offeringName']
                    securityType: nil
                }
            },
            type: "subscription"
        }
    }
    
    outJson = JSON(newJ)
    outObject = JSON.parse(outJson, object_class: OpenStruct)
    inJson = JSON(old_json)
    inObject = JSON.parse(inJson, object_class: OpenStruct)


    outObject.data.attributes.investAmount = inObject.investor.investAmount

    investor = outObject.data.attributes.investors[0]
    investor.accreditationType = inObject.investor.accreditation
    investor.entityType = inObject.investor.entityType
    investor.emailAddress = inObject.investor.email
    investor.isPrimary = true
    investor.primaryPhone = inObject.investor.phone
    
    #====== load different investor types ======
    if inObject.investor.investorType == 'ENTITY'
        investor.investorType = inObject.investor.investorType
        investor.accountBusinessName = inObject.investor.name
        investor.investmentAmount = inObject.investAmount
        investor.ein = setTaxId (inObject.investor.taxId)
        investor.entityType = inObject.investor.investorSubType
        investor.dateOfBirth = inObject.investor.dob
        investor.name = inObject.investor.name

        #Fill signatory with default if not given in request
        if inObject.investor.signatory != nil 
            investor.signatory.title = inObject.investor.signatory.title
            investor.signatory.address.city = inObject.investor.signatory.city
            investor.signatory.address.street1 = inObject.investor.signatory.address
            investor.signatory.address.stateProv = inObject.investor.signatory.state
            investor.signatory.address.postalCode = inObject.investor.signatory.zip
            investor.signatory.address.country = 'USA' 
            investor.signatory.dateOfBirth =inObject.investor.signatory.dob
            investor.signatory.lastName = inObject.investor.signatory.lastName
            investor.signatory.firstName = inObject.investor.signatory.firstName
            investor.signatory.signatoryAuthority = inObject.investor.signatory.signatoryAuthority
            investor.signatory.ssn = setTaxId (inObject.investor.signatory.taxId) 
        else 
            #Signatory is required. Fill signatory with default if not given in request 
            investor.signatory.address.city = inObject.investor.city
            investor.signatory.address.street1 = inObject.investor.address
            investor.signatory.address.stateProv = inObject.investor.state
            investor.signatory.address.postalCode = inObject.investor.zip
            investor.signatory.address.country = 'USA'
            investor.signatory.dateOfBirth =inObject.investor.dob
            investor.signatory.lastName = inObject.investor.lastName
            investor.signatory.firstName = inObject.investor.firstName
            investor.signatory.signatoryAuthority = true
            investor.signatory.ssn = setTaxId (inObject.investor.signatory.taxId) 
        end 

    elsif inObject.investor.investorType == 'INDIVIDUAL'
        #INDIVIDUAL
        investor.investorType = 'INDIVIDUAL'
        investor.firstName = inObject.investor.firstName
        investor.lastName = inObject.investor.lastName
        investor.dateOfBirth = inObject.investor.dob
        investor.ssn = setTaxId (inObject.investor.taxId)
        
    end

    #fill investor address
    investor.address.street1 = inObject.investor.address
    investor.address.city = inObject.investor.city
    investor.address.stateProv = inObject.investor.state
    investor.address.postalCode = inObject.investor.zip
    investor.address.country = 'USA'

    outObject.data.attributes.investors[0] = investor
        
    fundingMethod = outObject.data.attributes.fundingMethods[0]
    # # #  ====== load different payment method types ====== # # #
    case inObject.paymentType
    when 'ACH'
        fundingMethod.accountNumber = inObject.account.number

        #fill accountType with default value if not given
        if inObject.account.bankAccountType != nil
            fundingMethod.accountType = accountType.upcase
        else
            fundingMethod.accountType = 'CHECKING'
        end

        #fill bankName with default value if not given
        if inObject.account.bankName != nil
            fundingMethod.bankName = inObject.account.bankName
        else 
            fundingMethod.bankName = 'N/A'
        end 
            
        fundingMethod.paymentType = 'ACH'
        fundingMethod.routingNumber = inObject.account.routing
        fundingMethod.accountBusinessName = inObject.account.accountBusinessName
        fundingMethod.accountFirstName = inObject.account.accountFirstName
        fundingMethod.accountLastName = inObject.account.accountLastName
        fundingMethod.investmentAmount = inObject.investAmount.to_s

        if inObject.account.address != nil
            fundingMethod.address.street1 = inObject.account.address
            fundingMethod.address.city = inObject.account.city
            fundingMethod.address.stateProv = inObject.account.state
            fundingMethod.address.postalCode = inObject.account.zip
            fundingMethod.address.country = 'USA'
        end

    when 'WIRE'
        fundingMethod.paymentType = 'WIRE'
        fundingMethod.investmentAmount = inObject.investAmount.to_s
    end
        
    newWFRequest = ConvertToJson(outObject)
    return newWFRequest
end


# ========================
# ==== helper methods ====
# =======================