require 'base64'
require 'mime/types'
require 'json'
require 'ostruct'


class WealthForge::Investment
    def self.create(params = {})
        new_request = create_subscription(params)
        WealthForge::Connection.post "subscriptions", new_request
    end

    def self.get(investment_id)
        WealthForge::Connection.get "subscriptions/#{investment_id}", nil
    end



    # def self.create_subscription_agreement(investment_id, params)
    #     # TODO: complete file upload

    #     mapped_params = {
    #         status: {code: 'FILE_INPROGRESS', active: true},
    #         mimeType: MIME::Types.type_for(params[:filename]).first.to_s,
    #         folder: {parentFolder: {code: 'DUE_DILIGENCE'}},
    #         fileName: params[:filename],
    #         displayTitle: params[:filename],
    #         content: Base64.strict_encode64(params[:file]),
    #         parent: params[:parent]
    #     }

    #     WealthForge::Connection.put "investment/#{investment_id}/subscriptionAgreement", mapped_params
    # end

    def self.create_subscription(old_json)
        
        wf_model = {
            data: {
                attributes: {
                    investors: [
                        {
                            accreditationType: nil,
                            address: {
                                city: nil,
                                country: nil,
                                postalCode: nil,
                                stateProv: nil,
                                street1: nil,
                                street2: nil
                            },
                            crdNumber: nil,
                            dateOfBirth: nil,
                            emailAddress: nil,
                            firstName: nil,
                            investorType: nil,
                            isPrimary: nil,
                            lastName: nil,
                            name: nil,
                            primaryPhone: nil,
                            ssn: nil,
                            ein: nil,                        
                            signatory: {
                                title: nil,
                                address: {
                                    city: nil,
                                    street1: nil,
                                    street2: nil,
                                    stateProv: nil,
                                    postalCode: nil, 
                                    country: nil
                                },
                                dataOfBirth: nil,
                                lastName: nil,
                                fistName: nil,
                                signatoryAuthority: nil,
                                taxId: nil 
                            }
                        }
                    ],
                    fundingMethods: [
                        {
                            accountFirstName: nil,
                            accountLastName: nil,
                            accountNumber: nil,
                            accountType:nil,
                            bankName: nil,
                            routingNumber: nil,
                            investmentAmount: nil,
                            numberOfShares: nil, 
                            numberOfNotes: nil,
                            paymentType: nil
                        }
                    ],
                    investmentAmount: nil,
                    offering: {
                        id: nil, 
                        name: nil, 
                        securityType: nil
                    }
                },
                type: "subscription"
            }
        }
        
        new_wf_request = JSON(wf_model)
        wf_object = JSON.parse(new_wf_request, object_class: OpenStruct)
        in_request = JSON(old_json)
        in_object = JSON.parse(in_request, object_class: OpenStruct)

        #== hydrate wf_object with data from depreciated request
        wf_object.data.attributes.investAmount = in_object.amount     
        wf_object.data.attributes.investors[0] = wf_investor(in_object.investor, wf_object.data.attributes.investors[0])
        wf_object.data.attributes.fundingMethods[0] = wf_funding_method(in_object, wf_object.data.attributes.fundingMethods[0])
        wf_object.data.attributes.Offering = wf_offering_details(in_object, wf_object.data.attributes.offering)

        new_wf_request = WealthForge::Util.convert_to_json wf_object

        return new_wf_request
    end

    #fill data.attributes.investors
    def self.wf_investor(request, investor)

        # fill common entity/individual common properties
        investor.accreditationType = request.accreditation
        investor.emailAddress = request.email
        investor.isPrimary = true
        investor.primaryPhone = request.phone
        investor.crdNumber = request.crdNumber

        # investor address
        investor.address.street1 = request.address
        investor.address.city = request.city
        investor.address.stateProv = request.state
        investor.address.postalCode = request.zip
        investor.address.country = 'USA'

        # since only one investor is sent it will always be primary
        investor.isPrimary = true 

        # load different investor types ENTITY / INDIVIDUAL
        if request.investorType == 'ENTITY'
            investor.investorType = request.investorType
            investor.entityType = request.investorSubType # valid values are JOINT, LLC, TRUST, PARTNERSHIP or OTHER
            investor.name = request.name
            investor.ein = WealthForge::Util.format_tax_id (request.taxId)

            # signatory required for ENTITY investorType
            # fill signatory with default if not given in request
            if request.signatory != nil 
                investor.signatory.firstName = request.signatory.firstName
                investor.signatory.lastName = request.signatory.lastName
                investor.signatory.dateOfBirth =request.signatory.dob
                investor.signatory.address.street1 = request.signatory.address
                investor.signatory.address.city = request.signatory.city
                investor.signatory.address.stateProv = request.signatory.state
                investor.signatory.address.postalCode = request.signatory.zip
                investor.signatory.address.country = 'USA' 
                investor.signatory.ssn = WealthForge::Util.format_tax_id request.signatory.taxId
                investor.signatory.title = request.signatory.title
                investor.signatory.signatoryAuthority = request.signatory.signatoryAuthority
            else 
                # signatory is required
                # fill signatory with default if not given 
                investor.signatory.firstName = request.firstName
                investor.signatory.lastName = request.lastName
                investor.signatory.dateOfBirth =request.dob
                investor.signatory.address.street1 = request.address
                investor.signatory.address.city = request.city
                investor.signatory.address.stateProv = request.state
                investor.signatory.address.postalCode = request.zip
                investor.signatory.address.country = 'USA'
                investor.signatory.ssn = WealthForge::Util.format_tax_id (request.taxId) 
                investor.signatory.title = "N/A"
                investor.signatory.signatoryAuthority = true
            end 
        elsif request.investorType == 'INDIVIDUAL'
            investor.investorType = 'INDIVIDUAL'
            investor.firstName = request.firstName
            investor.lastName = request.lastName
            investor.dateOfBirth = request.dob
            investor.ssn = WealthForge::Util.format_tax_id (request.taxId)

            # signatory not sent with individual type
            investor.signatory = nil
        end

        return investor
    end

    # fill data.attributes.fundingMethods
    def self.wf_funding_method (request, fundingMethod)
        # # #  ====== load different payment method types of ACH or WIRE ====== # # #
        account = request.account
        
        case request.paymentType
        when 'ACH'
            fundingMethod.accountNumber = account.number

            # fill accountType with default value if not given
            # valid values are CHECKING or SAVINGS
            if account.bankAccountType != nil
                fundingMethod.accountType = account.bankAccountType.upcase
            else
                fundingMethod.accountType = 'CHECKING'
            end

            #fill bankName with default value if not given
            if account.bankName != nil
                fundingMethod.bankName = account.bankName
            else 
                fundingMethod.bankName = 'N/A'
            end 
                
            fundingMethod.paymentType = 'ACH'
            fundingMethod.routingNumber = account.routing
            fundingMethod.accountBusinessName = account.name
            fundingMethod.accountFirstName = account.firstName
            fundingMethod.accountLastName = account.lastName
        when 'WIRE'
            fundingMethod.paymentType = 'WIRE'
        end

        fundingMethod.investmentAmount = request.amount.to_s
        return fundingMethod
    end 

    # fill data.attributes.Offering
    def self.wf_offering_details (request, offering)
        offering.name = request.offeringName
        offering.securityType = request.securityType
        offering.id = request.offerDetail
        return offering
    end
end