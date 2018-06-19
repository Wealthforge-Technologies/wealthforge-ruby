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


  t = {
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
        },
        theme: {
          logo: old_json['busLogo'], # lexshares won't be using these theme values anyway vvvvvv
          mobilelogo: old_json['busLogo'],
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
 return t
end
