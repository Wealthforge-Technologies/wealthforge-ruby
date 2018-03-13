require 'mime/types'

class WealthForge::Subscription

  def self.all
    WealthForge::Connection.get "subscriptions", nil
  end


  # def self.create(params)
  #   WealthForge::Connection.post 'offering/setup', params
  # end
  #
  #
  # def self.get(offering_id)
  #   WealthForge::Connection.get "offering/#{offering_id}", nil
  # end


end
