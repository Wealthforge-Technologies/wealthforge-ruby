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
    wf_object.data.attributes = wfOffering(attributes, in_object)
    new_wf_request = WealthForge::Util.convertToJson wf_object
    
    return new_wf_request
  end 
 
  def self.wfOffering (offering, request)

      if request.title != nil 
        offering.title = request.title
      else 
        offering.title = 'N/A'
      end

      offering.issuerId = request.issuer
      offering.offeringType = wfOfferingType(request.offerDetails[0].regulationType)
      offering.startDate = request.dateStart
      offering.endDate = request.dateEnd
      offering.minimumRaise = WealthForge::Util.wfCurrency(request.offerDetails[0].minRaise)
      offering.maximumRaise = WealthForge::Util.wfCurrency(request.offerDetails[0].maxRaise)
      offering.minimumInvestment = WealthForge::Util.wfCurrency(request.offerDetails[0].minInvestment)
      offering.paymentMethods = request.offerDetails[0].paymentMethods
      offering.status = "PENDING_REVIEW"
      offering.securityTypes[0] = wfSecurityType(offering.securityTypes[0], request)

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

  def self.wfSecurityType(security_type, request)
    case request.offerDetails[0].instrumentType
    when 'SHARE_COMMON'
      security_type.type = wfSecurityTypeCode(request.offerDetails[0].instrumentType)
      security_type.securityPrice = WealthForge::Util.wfCurrency(request.offerDetails[0].price)     
      security_type.numSharesOffered = request.totalShare.to_i
    end 
    return security_type
  end 

  def self.wfOfferingType (type)
    offering_type = {
      "MEMO_EQUITY_D506B" => "REG_D_506_B", 
      "MEMO_EQUITY_D506C" => "REG_D_506_C" 
    }
    return offering_type[type]
  end

  def self.wfSecurityTypeCode (type)
    security_type = {
      "SHARE_COMMON" => "COMMON_STOCK"
    }
   return security_type[type]
  end


end