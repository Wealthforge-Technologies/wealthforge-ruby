require 'json'
require 'pp'



offering_type_enum = {
  'REG_D_506_B' => 'MEMO_EQUITY_D506B',
  'REG_D_506_C' => 'MEMO_EQUITY_D506C'
}

old_json = JSON['{
    "issuer":"857355020872",
    "totalShare":1000000,
    "previouslyRaised":0,
    "minRaise":999999,
    "maxRaise":1000000,
    "offerDetails":[
        {
            "minInvestment":50000,
            "minRaise":999999,
            "maxRaise":1000000,
            "issued":1000000,
            "price":1,
            "postMoneyValuation":1000000,
            "offerDetailType":"EQUITY",
            "instrumentType":"SHARE_COMMON",
            "regulationType":"MEMO_EQUITY_D506C"
        }
    ],
    "status":"OFFERING_PENDING",
    "dateStart":"2019-03-05",
    "dateEnd":"2016-05-06"
}']


new_json = {
  :attributes => {
    :title => 'aadddd',
    :offeringType => offering_type_enum.key(old_json['offerDetails'][0]['regulationType']),
    :startDate => old_json['dateStart'],
    :endDate => old_json['dateEnd'],
    :minimumRaise => old_json['minRaise'],
    :maximumRaise => old_json['maxRaise'],
    :minimumInvestment => old_json['minInvestment'],
    :paymentMethod => 'ACH', #<hardcoded>
    :classTitle => '',    # not sure if this is even in the old!
    :securityTypes => {
      :type => '',
    },
    :type => 'offerings'
  }
}



case old_json['offerDetails'][0]['instrumentType']
when 'SHARE_COMMON'
  new_json[:attributes][:securityTypes][:type] = 'COMMON_STOCK' #
  new_json[:attributes][:securityTypes][:securityPrice] = old_json['offerDetails'][0]['price']
  new_json[:attributes][:securityTypes][:numSharesOffered] = old_json['totalShare'].to_i
else
  raise '__PARSING ERROR__  INVALID / UNMAPPED offerDetailType from capForge request offering/create!'
end

pp new_json
