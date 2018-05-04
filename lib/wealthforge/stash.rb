require 'json'
require 'pp'

class WealthForge::Stash


  def self.create(params)
    WealthForge::Connection.post "stashes", params
  end


  def self.get(stash_id)
    WealthForge::Connection.get "stashes/#{stash_id}", nil
  end


  def self.update(stash_id, params)
    WealthForge::Connection.put "stashes/#{stash_id}", params
  end

end

