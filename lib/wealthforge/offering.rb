require 'json'

class WealthForge::Offering

  # def self.all
  #   WealthForge::Connection.get "offering", nil
  # end


  def self.create(params)

    # TODO: old request to new

    WealthForge::Connection.post "offerings", params
  end


  def self.get(offering_id)
    WealthForge::Connection.get "offerings/#{offering_id}", nil
  end



end
