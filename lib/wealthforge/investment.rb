require 'base64'
require 'mime/types'
require 'json'


class WealthForge::Investment


  def self.create(params)
    WealthForge::Connection.post "subscriptions", old_to_new_create(params)
  end


  def self.get(investment_id)
    WealthForge::Connection.get "investment/#{investment_id}", nil
  end


  def self.update(investment_id, params)
    WealthForge::Connection.put "investment/#{investment_id}", params
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



  # UNUSED BY LEXSHARES:

  # def self.all
  #   WealthForge::Connection.get "subscriptions", nil
  # end
  #
  #
  # def self.redirect_url(investment_id)
  #   WealthForge::Connection.get "investment/#{investment_id}/start", nil
  # end
  #
  # def self.status(investment_id)
  #   WealthForge::Connection.get "investment/#{investment_id}/status", nil
  # end
  #
  #
  # def self.account(investment_id)
  #   WealthForge::Connection.get "investment/#{investment_id}/account", nil
  # end
  #
  #
  # def self.update_account(investment_id, params)
  #   WealthForge::Connection.put "investment/#{investment_id}/account", params
  # end
  #
  #
  # def self.approve(investment_id)
  #   WealthForge::Connection.put "investment/#{investment_id}/approve", nil
  # end
  #
  #
  # def self.approve_subscription(investment_id)
  #   WealthForge::Connection.put "investment/#{investment_id}/approveSubscriptionAgreement", nil
  # end
  #
  #
  # def self.certificate(investment_id)
  #   WealthForge::Connection.get "investment/#{investment_id}/certificate", nil, true
  # end
  #
  #
  # def self.due_diligence(investment_id)
  #   WealthForge::Connection.get "investment/#{investment_id}/duediligence", nil
  # end
  #
  #
  # def self.subscription_agreement(investment_id)
  #   WealthForge::Connection.get "investment/#{investment_id}/subscriptionAgreement", nil
  # end


end




# ========================
# ==== helper methods ====
# ========================



private
def old_to_new_create(old_json)

  # TODO: copy from scratch file
  ''
end