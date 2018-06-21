require 'base64'
require 'mime/types'
require 'json'
require 'ostruct'

#Converts ObjectStruct to JSON 
class WealthForge::Util
    def self.convert_to_json(object)
        new_request = {}
        object.each_pair do |key, value|
            new_request[key] = case value
            when OpenStruct then convert_to_json(value)
            when Array then value.map { |v| convert_to_json(v) }
                else value
            end
        end
        return new_request
    end

    #Removes '-' from taxid
    def self.format_tax_id (taxId)
        id = nil
        if taxId != nil 
            id = taxId.gsub("-", "")
        end
        return id
    end
end



