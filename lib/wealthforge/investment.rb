require 'base64'
require 'mime/types'
require 'json'


class WealthForge::Investment


  def self.create(params)
    WealthForge::Connection.post "subscriptions", old_to_new_create(params)
  end


  # lexshares will sometimes use this GET
  def self.get(investment_id)
    WealthForge::Connection.get "investment/#{investment_id}", nil
  end


  def self.create_subscription_agreement(investment_id, params)
    mapped_params = {
        status: {code: 'FILE_INPROGRESS', active: true},
        mimeType: MIME::Types.type_for(params[:filename]).first.to_s,
        folder: {parentFolder: {code: 'DUE_DILIGENCE'}},
        fileName: params[:filename],
        displayTitle: params[:filename],
        content: Base64.strict_encode64(params[:file]),
        parent: params[:parent]
    }

    WealthForge::Connection.put "investment/#{investment_id}/subscriptionAgreement", mapped_params
  end

end




# ========================
# ==== helper methods ====
# ========================



private
def old_to_new_create(old_json)

  # TODO: copy from scratch file
  ''
end