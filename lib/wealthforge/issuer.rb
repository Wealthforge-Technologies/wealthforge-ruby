# require_relative './enums'
require 'json'
require 'pp'


class WealthForge::Issuer

  def self.create(params = {})
    newjson = create_issuer(params)
    WealthForge::Connection.post "issuers", newjson
  end

  def self.create_issuer(old_json)

    wf_model = {
      data: {
        attributes: {
          address: {
            city: nil,
            country: nil,
            postalCode: nil,
            stateProv: nil,
            street1: nil,
            street2: nil
        
          },
          bank: nil,
          contact: {
            emailAddress: nil,
            firstName: nil,
            lastName:nil,
            phoneNumber: nil,
            title: nil
          },
          ein: nil,
          entityType: nil,
          name: nil,
          organizationType: nil,
          phoneNumber: nil,
          stateOfIncorporation: nil,
          sponsorID: nil
        },
        type: "issuer"
      }
    }

    new_wf_request = JSON(wf_model)
    in_request = JSON(old_json)

    wf_object = JSON.parse(new_wf_request, object_class: OpenStruct) 
    in_object = JSON.parse(in_request, object_class: OpenStruct)

    attributes = wf_object.data.attributes 
    wf_object.data.attributes = wf_issuer(attributes, in_object)
    new_wf_request = WealthForge::Util.convert_to_json wf_object
    
    return new_wf_request
  end

  # fills data.attribute.issuer
  def self.wf_issuer(issuer, request)
    issuer.bank = request.bank 
    issuer.ein = request.ein
    issuer.entityType = wf_convert_entity_type(request.entityType.code)
    issuer.name = request.busName
    issuer.organizationType = 'ISSUER'
    issuer.phoneNumber = request.phone
    issuer.stateOfIncorporation = request.stateOfFormation.code
    issuer.sponsorID = request.sponsor 
    
    issuer.address = wf_issuer_address(issuer.address, request)
    issuer.contact = wf_issuer_contact(issuer.contact, request)
    return issuer
  end

  # fills data.attribute.issuer.contact
  def self.wf_issuer_contact(contact, request)
    contact.emailAddress = request.email
    contact.firstName = request.firstName
    contact.lastName = request.lastName
    contact.phoneNumber = request.phone
    contact.title = request.founderTitle

    return contact
  end

  #fills data.attribute.issuer.address
  def self.wf_issuer_address(address, request)
    address.street1 = request.address
    address.city = request.city
    address.stateProv = request.state.code
    address.postalCode = request.zip
    address.country = request.country.code

    return address
  end

  def self.wf_convert_entity_type (type)
    entity = {
      "ENTITY_TYPE_CCOR" => "OTHER", 
      "ENTITY_TYPE_LLC" => "LLC",
      "ENTITY_TYPE_PART" => "PARTNERSHIP",
      "ENTITY_TYPE_SCOR" => "OTHER", 
      "ENTITY_TYPE_TRUST" => "TRUST"
    }
    return entity[type]
  end

end 