require 'json'
require 'pp'



offering_type_enum = {
    'REG_D_506_B' => 'MEMO_EQUITY_D506B',
    'REG_D_506_C' => 'MEMO_EQUITY_D506C'
}


new_json = JSON['
  {
    "id": "cf99116c-1209-47a7-a52a-46332ed7245f",
    "created_at": "2018-03-23T14:57:02.97934Z",
    "created_by": "11111111-1111-1111-1111-111111111111",
    "updated_at": "2018-03-23T14:57:02.97934Z",
    "title": "title 11",
    "offering_type": "REG_D_506_B",
    "start_date": "2008-01-02T00:00:00Z",
    "end_date": "2008-01-03T00:00:00Z",
    "minimum_raise": "27.00",
    "maximum_raise": "27.01",
    "minimum_investment": "123333",
    "payment_method": "ACH",
    "class_title": "RCP debt loan terms (3 yr, 4 yr, 5 yr)",
    "security_types":  [{
      "type": "DEBT",
      "security_price": "1500653.29",
      "num_notes_offered": 1010,
      "interest_rate": "0.059",
      "num_months_to_maturity": 73,
      "distribution_frequency": "MONTHLY"
    }]
  }
']



#
# old_json = JSON[{
#           :data => {
#             :id => "3d609eb4-93aa-444c-be02-72ee5ec584ad",
#             :status => {
#               :code => "OFFERING_ACTIVE",
#               :updatedAt => 1387358184294,
#             },
#             :wfStatus => {
#               :code => "OFFERING_ACTIVE",
#               :updatedAt => 1387358184294,
#             },
#             :issuer => {
#               :id => "df713899-8d5f-4f30-ab1e-7c634ef83815",
#               :country => {
#                 :code => "US",
#                 :name => "United States"
#               },
#               :stateOfFormation => {
#                 :code => "NJ",
#                 :name => "New Jersey",
#               },
#               :state =>{
#                 :code => "NY",
#                 :name => "New York",
#               },
#               :entityType => {
#                 :code => "ENTITY_TYPE_LLC",
#                 :name => "LLC",
#                 :updatedAt => 1382459455000,
#               },
#               :busName => "LexInvest Fund 49 LLC",
#               :busLogo => "https://www.lexshares.com/assets/lexshares-logo-e240ae59319eaeca74cf80bfb738aa05.png",
#               :founderTitle => "Manager",
#               :founderName => "Joe Greenberg",
#               :email => "test@gmail.com",
#               :ssn => nil,
#               :ein => "12345",
#               :address => "33 Whitehall Street",
#               :address2 => nil,
#               :city => "New York",
#               :zip => "10004",
#               :accountingFirm => "Downey & Co. LLP",
#               :dateOfFormation => 1449360000000
#             },
#             :minRaise => 399999.00,
#             :maxRaise => 400000.00,
#             :totalShare => 400000,
#             :dateStart => 1449378000000,
#             :dateEnd => 1451451600000,
#             :paymentOptions => [
#             {
#               :code => "ACH",
#               :name => "ACH",
#               :updatedAt => 1412771282248
#             }],
#             :offerDetails => [
#             {
#               :id => "d9e78256-0637-4d03-b94a-58a2cae3ea47",
#               :offering => "3d609eb4-93aa-444c-be02-72ee5ec584ad",
#               :instrumentType => {
#                   :code => "SHARE_COMMON",
#                   :updatedAt => 1383128671000,
#               },
#               :regulationType => {
#                 :code => "MEMO_EQUITY_D506C",
#                 :active => false,
#                 :offerDetailType => {
#                   :code => "EQUITY",
#                   :active => true,
#                   :updatedAt => 1382473855000,
#                 },
#               },
#             }],
#           },
#           "status":200,
#           "code":nil,
#           }
# ]


# TODO: do something about nil -> null -- lex are expecting null but ruby uses nil
# TODO: also true/false??
old_json = JSON[
    :data => {
        :id => '',
        :status => {
            :code => '',
            :updatedAt => 0,
        },
        :wfStatus => {
            :code => '',
            :updatedAt => 0,
        },
        :issuer => {
            :id => '',
            :country => {
                :code => '',
                :name => ''
            },
            :stateOfFormation => {
                :code => '',
                :name => '',
            },
            :state =>{
                :code => '',
                :name => '',
            },
            :entityType => {
                :code => '',
                :name => '',
                :updatedAt => 0,
            },
            :busName => '',
            :busLogo => '',
            :founderTitle => '',
            :founderName => '',
            :email => '',
            :ssn => nil,
            :ein => '',
            :address => '',
            :address2 => nil,
            :city => '',
            :zip => '',
            :accountingFirm => '',
            :dateOfFormation => 0
        },
        :minRaise => 0,
        :maxRaise => 0,
        :totalShare => 0,
        :dateStart => 0,
        :dateEnd => 0,
        :paymentOptions => [
            {
                :code => '',
                :name => '',
                :updatedAt => 0
            }],
        :offerDetails => [
            {
                :id => '',
                :offering => '',
                :instrumentType => {
                    :code => '',
                    :updatedAt => 0,
                },
                :regulationType => {
                    :code => '',
                    :active => false,
                    :offerDetailType => {
                        :code => '',
                        :active => true,
                        :updatedAt => 0,
                    },
                },
            }],
    },
    "status":200,
    "code":nil,

]



case new_json['security_types'][0]['type']
  when 'DEBT'

    # TODO: insert stuff for equity into json

    # new_json[:attributes][:securityTypes][:type] = 'INTERESTS' # TODO: pretty sure this is correct Equity = Interests???
    # new_json[:attributes][:securityTypes][:securityPrice] = ''
    # new_json[:attributes][:securityTypes][:numUnitsOffered] = old_json['totalShare']  # TODO: expecting number!, not sure if correct
    # new_json[:attributes][:securityTypes][:preferredReturn] = ''
    # new_json[:attributes][:securityTypes][:distributionFrequency] = ''


  else
    raise '__PARSING ERROR__  INVALID / UNMAPPED offerDetailType FROM capForge request!'
end

pp new_json