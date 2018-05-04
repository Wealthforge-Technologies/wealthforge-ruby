require 'json'
require_relative './enums'

class WealthForge::Offering


  # TODO: list of offerings
  # def self.all
  #   WealthForge::Connection.get "offering", nil
  # end


  def self.create(params)

    # if it does not start with data and has previouslyRaised then it is a lexShares request
    if params['data'].nil? && !params['previouslyRaised'].nil?
      WealthForge::Connection.post "offerings", old_to_new_create_offering(params)
    else

      pp params
      WealthForge::Connection.post "offerings", params
    end
  end


  def self.get(offering_id)
    # TODO: new request to old

    WealthForge::Connection.get "offerings/#{offering_id}", nil
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

              title: 'old to new offering from middleware',   #TODO: title?????
              offeringType: Enums::offering_type_enum.key(old_json['offerDetails'][0]['regulationType']),
              startDate: old_json['dateStart'],
              endDate: old_json['dateEnd'],
              minimumRaise: old_json['minRaise'].to_s,
              maximumRaise: old_json['maxRaise'].to_s,
              minimumInvestment: old_json['offerDetails'][0]['minInvestment'].to_s,
              paymentMethods: ['ACH'], # <hardcoded> TODO: capforge says they use ACH, WIRE, IRE here!
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