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
        :paymentMethod => '', # not sure if this is even in the old!
        :classTitle => '',    # not sure if this is even in the old!
        :securityTypes => {
            :type => '',
        },
        :type => 'offerings'
    }
}




case old_json['offerDetails'][0]['offerDetailType']
  when 'EQUITY'
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