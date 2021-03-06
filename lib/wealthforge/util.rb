require 'base64'
require 'mime/types'
require 'json'
require 'ostruct'

# Converts ObjectStruct to JSON 
class WealthForge::Util
    def self.convert_to_json(object)
        new_request = {}

        #assumes object is a strings if not a key/value pair
        a = object.respond_to?(:each_pair)
        if a == false 
            return object.to_s
        end

        object.each_pair do |key, value|
            new_request[key] = case value
            when OpenStruct then convert_to_json(value)
            when Array then value.map { |v| convert_to_json(v) }
            else value
            end
        end
        return new_request
    end

    # Removes '-' from tax_id
    def self.format_tax_id (tax_id)
        id = nil
        if tax_id != nil 
            id = tax_id.gsub("-", "")
        end
        return id
    end

    # Ensures currency has 2 decimals
    def self.wf_currency (amount)
        if amount == nil 
          return nil
        end 
    
        s = amount.to_s
        indx = s.index('.')
        len = s.length
    
        if len == 0
          s = 0.00
        elsif indx == (len - 1)
          s = s << '00'
        else
          s = s = s.index('.') ? s.length - (s.index('.') + 1) == 1 ? s << '0' : s : s << '.00'   
        end 
    
        return s
      end
end



