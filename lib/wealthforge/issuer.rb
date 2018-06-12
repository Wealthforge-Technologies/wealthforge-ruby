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


  new_json = {
    data: {
      attributes: {
        title: old_json['bus_name'],
        orgType: 'ISSUER',
        phone: old_json['phone'],
        legalName: old_json['bus_name'], # NOTE: same as title
        entityType: Enums::entity_type_enum[old_json['entity_type']],
        stateOfIncorporation: old_json['state_of_formation'],
        pointOfContactName: old_json['founder_name'],
        pointOfContactTitle: old_json['founder_title'],
        pointOfContactEmail: '',          # todo: hardcode -- what should it be?
        bank: 'lexshares_bank',             # todo: hardcode???? -- will be an ID ???
        ein: old_json['ein'],
        address: {
          street1: old_json['address'],
          street2: old_json['address2'],
          city: old_json['city'],
          stateProv: old_json['state'],
          postalCode: old_json['zip'],
          country: 'USA'
        },
        theme: {
          logo: old_json['bus_logo'], # lexshares won't be using these theme values anyway vvvvvv
          mobilelogo: old_json['bus_logo'],
          linkBack: 'lexshares.com',
          linkBackDisplayText: 'go back to lexshares',
          primary: '000000',
          secondary: '000000',
          accent: '000000',
          docusignBrandID: '11111111-1111-1111-1111-111111111111' #todo: does this need to be changed???
        }
      },
      type: 'organization',
    }
  }

end
