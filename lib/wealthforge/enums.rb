class Enums

  class << self
    attr_accessor :state_code_enum
    attr_accessor :payment_code_name_enum
    attr_accessor :investment_status_enum
    attr_accessor :investor_accreditation_enum
    attr_accessor :offering_type_enum
    attr_accessor :entity_type_enum
    attr_accessor :payment_type_enum
  end


  @offering_type_enum = {
      # new: old
      'REG_D_506_B' => 'MEMO_EQUITY_D506B',
      'REG_D_506_C' => 'MEMO_EQUITY_D506C'
  }

  @state_code_enum = {
    'AL' => 'Alabama',
    'AK' => 'Alaska',
    'AZ' => 'Arizona',
    'AR' => 'Arkansas',
    'CA' => 'California',
    'CO' => 'Colorado',
    'CT' => 'Connecticut',
    'DE' => 'Delaware',
    'DC' => 'District of Columbia',
    'FL' => 'Florida',
    'GA' => 'Georgia',
    'HI' => 'Hawaii',
    'ID' => 'Idaho',
    'IL' => 'Illinois',
    'IN' => 'Indiana',
    'IA' => 'Iowa',
    'KS' => 'Kansas',
    'KY' => 'Kentucky',
    'LA' => 'Louisiana',
    'ME' => 'Maine',
    'MD' => 'Maryland',
    'MA' => 'Massachusetts',
    'MI' => 'Michigan',
    'MN' => 'Minnesota',
    'MS' => 'Mississippi',
    'MO' => 'Missouri',
    'MT' => 'Montana',
    'NE' => 'Nebraska',
    'NV' => 'Nevada',
    'NH' => 'New Hampshire',
    'NJ' => 'New Jersey',
    'NM' => 'New Mexico',
    'NY' => 'New York',
    'NC' => 'North Carolina',
    'ND' => 'North Dakota',
    'OH' => 'Ohio',
    'OK' => 'Oklahoma',
    'OR' => 'Oregon',
    'PA' => 'Pennsylvania',
    'RI' => 'Rhode Island',
    'SC' => 'South Carolina',
    'SD' => 'South Dakota',
    'TN' => 'Tennessee',
    'TX' => 'Texas',
    'UT' => 'Utah',
    'VT' => 'Vermont',
    'VA' => 'Virginia',
    'WA' => 'Washington',
    'WV' => 'West Virginia',
    'WI' => 'Wisconsin',
    'WY' => 'Wyoming'
  }


  # code => name for capforge data
  @payment_code_name_enum = {
    'WIRE' => 'Wire',
    'ACH' => 'ACH',
    'IRA' => 'IRA'
  }


  @investment_status_enum = {
      # note that nothing is changed investment-wise in capforge by parth
      # new_status: ['old status code', 'old status name'],
      'INVESTMENT_SIGNED' => ['INVESTMENT_DOCS_SIGNED','Signed'],
      'INVESTMENT_IN_PROGRESS' => ['INVESTMENT_INPROGRESS','In Progress'],
      'INVESTMENT_APPROVED' => ['INVESTMENT_APPROVED','Approved'],
      'INVESTMENT_BD_APPROVAL' => ['---','---'],
      'INVESTMENT_ISSUER_COUNTERSIGNED' => ['--reg a only--','---'],
      'INVESTMENT_DECLINED' => ['INVESTMENT_INACTIVE','Inactive'],
      'INVESTMENT_DILIGENCE_REVIEW' => ['INVESTMENT_PENDING','Pending'],
      'INVESTMENT_SUPERVISOR_REVIEW' => ['---','---'],
  }


  @investor_accreditation_enum = {
      # new: [old code, old name]
      'BENEFIT_IDENTITY' => ['--not used anymore--', '-----'],
      'DECLINE' => ['OTHER', 'Other'],
      'GENERIC_IDENTITY' => ['IDENTITY', 'Identity'],
      'GENERIC_TOTAL_ASSETS' => ['TOTAL_ASSETS', 'Total Assets'],
      'INCOME' => ['--not used anymore--', '-----'],
      'INCOME_NET_WORTH' => ['INCOME_OR_NET_WORTH', 'Income or Net Worth'],
      'INDIVIDUAL_INCOME' => ['INCOME', 'Income'],
      'MARRIED_INCOME' => ['INCOME', 'Income'],
      'NET_WORTH' => ['NET_WORTH', 'Net Worth'],
      'NOT_ACCREDITED' => ['NOT_ACCREDITED', 'Not Accredited'],
      'TRUST_TOTAL_ASSETS' => ['TOTAL_ASSETS', 'Total Assets'],
  }


  @entity_type_enum = {
    # old: new
    'ENTITY_TYPE_CCOR' => 'OTHER', # (C-CORP) -- ui-proteus doesn't have this
    'ENTITY_TYPE_LLC' => 'LLC',
    'ENTITY_TYPE_PART' => 'PARTNERSHIP',
    'ENTITY_TYPE_SCOR' => 'OTHER', # (S-CORP) -- ui-proteus doesn't have this
    'ENTITY_TYPE_TRUST' => 'TRUST',
  }





  @payment_type_enum = {
      # old: new
      'ACH' => 'ACH',
      'WIRE' => 'WIRE',
      'IRA' => 'IRA',
      'CHECK' => 'CHECK',
      'EXCHANGE_1031' => '1031_EXCHANGE'
  }

end
