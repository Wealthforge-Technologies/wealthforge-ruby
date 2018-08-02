require 'json'
# require_relative './enums'

class WealthForge::Offering
  def self.create(params)
    WealthForge::Connection.post "offerings", createOffering(params)
  end

  def self.createOffering(old_json)

    wf_model = {
      data: {
        attributes:{
          title: nil,
          issuerId: nil,
          offeringType: nil,
          startDate: nil,
          endDate: nil,
          minimumRaise: nil,
          maximumRaise: nil,
          minimumInvestment: nil,
          paymentMethods: nil,
          status: nil,
          securityTypes: [{
            type: nil,
            securityPrice: nil,
            numSharesOffered: nil
          }] 
        },
        type: 'offerings'
      }
    }
    new_wf_request = JSON(wf_model)
    wf_object = JSON.parse(new_wf_request, object_class: OpenStruct)

    in_request = JSON(old_json)
    in_object = JSON.parse(in_request, object_class: OpenStruct)

    attributes = wf_object.data.attributes 
    wf_object.data.attributes = wf_offering(attributes, in_object)
    new_wf_request = WealthForge::Util.convert_to_json wf_object
    
    return new_wf_request
  end 
 
  def self.wf_offering (offering, request)

      offering.issuerId = request.issuer
      offering.offeringType = wf_offering_type(request.offerDetails[0].regulationType)
      offering.startDate = request.dateStart
      offering.endDate = request.dateEnd
      offering.minimumRaise = WealthForge::Util.wf_currency(request.offerDetails[0].minRaise)
      offering.maximumRaise = WealthForge::Util.wf_currency(request.offerDetails[0].maxRaise)
      offering.minimumInvestment = WealthForge::Util.wf_currency(request.offerDetails[0].minInvestment)
      offering.paymentMethods = request.offerDetails[0].paymentMethods
      offering.status = "PENDING_REVIEW"
      offering.securityTypes[0] = wf_security_type(offering.securityTypes[0], request)
      offering.title = request.offerDetails[0].title

      pp offering
      return offering
    end 
    
# TODO: should this go in stash
    # "previouslyRaised":0,
    # "offerDetails":[
    #     {
    #         "issued":1000000
    #         "postMoneyValuation":1000000,
    #         "offerDetailType":"EQUITY",
    #     }
    # ],

  def self.wf_security_type(security_type, request)
    case request.offerDetails[0].instrumentType
    when 'SHARE_COMMON'
      security_type.type = wf_security_type_code(request.offerDetails[0].instrumentType)
      security_type.securityPrice = WealthForge::Util.wf_currency(request.offerDetails[0].price)     
      security_type.numSharesOffered = request.totalShare.to_i
    end 
    return security_type
  end 

  def self.wf_offering_type (type)
    offering_type = {
      "MEMO_EQUITY_D506B" => "REG_D_506_B", 
      "MEMO_EQUITY_D506C" => "REG_D_506_C" 
    }
    return offering_type[type]
  end

  def self.wf_security_type_code (type)
    security_type = {
      "SHARE_COMMON" => "COMMON_STOCK"
    }
   return security_type[type]
  end


end