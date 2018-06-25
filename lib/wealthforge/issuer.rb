require_relative './enums'
require 'json'
require 'pp'


class WealthForge::Issuer

  def self.create(params = {})
    newjson = old_to_new_create_issuer(params)
    WealthForge::Connection.post "organizations", newjson
  end

end




private
def old_to_new_create_issuer(old_json)

  # {
  #   "address": "124 Investor Way",
  #   "city": "Boston",
  #   "state": { "code": "VA" },
  #   "zip": "02139",
  #   "country": { "code": "US" },
  #   "busName": "LexShares",
  #   "accountingFirm": "Accountants, LLC",
  #   "founderName": "James Smith",
  #   "stateOfFormation": { "code": "MD" },
  #   "entityType":  { "code": "ENTITY_TYPE_LLC"},
  #   "founderTitle": "CEO",
  #   "dateOfFormation": "2001-11-01",
  #   "ein": "999999999",
  #   "email": "wealthforge_api_test@mailinator.com",
  #   "phone": "2125551234"
  # }
  wf_model = {
    data: {
      attributes: {
        title: old_json['busName'],
        orgType: 'ISSUER',
        phone: old_json['phone'],
        legalName: old_json['busName'], # NOTE: same as title
        entityType: Enums::entity_type_enum[old_json['entityType']['code']],
        stateOfIncorporation: old_json['stateOfFormation']['code'],
        pointOfContactName: old_json['founderName'],
        pointOfContactTitle: old_json['founderTitle'],
        pointOfContactEmail: '',          # todo: hardcode -- what should it be?
        bank: 'lexshares_bank',             # todo: hardcode???? -- will be an ID ???
        ein: old_json['ein'],
        address: {
          street1: old_json['address'],
          street2: old_json['address2'],
          city: old_json['city'],
          stateProv: old_json['state']['code'],
          postalCode: old_json['zip'],
          country: 'USA'
        }
      },
      type: 'organization',
    }
  }

  new_wf_request = JSON(wf_model)
  wf_object = JSON.parse(new_wf_request, object_class: OpenStruct)
  in_request = JSON(old_json)
  in_object = JSON.parse(in_request, object_class: OpenStruct)

  wf_object.data.attributes.address

 return t
end
