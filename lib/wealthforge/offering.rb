require 'json'
require_relative './enums'

class WealthForge::Offering

  def self.create(params)

    WealthForge::Connection.post "offerings", old_to_new_create_offering(params)

  end

end


# ========================
# ==== helper methods ====
# ========================


private
def old_to_new_create_offering(old_json)

  new_json = {
    data: {
      attributes: {
        title: 'old to new offering from middleware', #TODO: title????? -- sent from issuer as busName!!!! -- save in stash??
        issuerId: '123456789',
        offeringType: Enums::offering_type_enum.key(old_json['offerDetails'][0]['regulationType']),
        startDate: old_json['dateStart'],
        endDate: old_json['dateEnd'],
        minimumRaise: old_json['minRaise'].to_s,
        maximumRaise: old_json['maxRaise'].to_s,
        minimumInvestment: old_json['offerDetails'][0]['minInvestment'].to_s,
        paymentMethods: ['ACH', 'WIRE'], # <hardcoded>
        status: 'DRAFT', # can be one of DRAFT, PENDING_REVIEW, ACTIVE, PAUSED TODO: which one should be sent?
        securityTypes: [{
          type: '', # defined below
        }]
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
      raise '__PARSING ERROR__  INVALID or UNMAPPED offerDetailType from capForge request offering/create!'
  end
  p new_json

  return new_json

end