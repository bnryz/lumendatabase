risk_trigger = RiskTrigger.create!(
  name: 'Submitter country code not US',
  matching_type: 'all'
)

RiskTriggerCondition.reset_column_information

RiskTriggerCondition.create!(
  field: 'submitter.country_code',
  value: 'us',
  negated: true,
  risk_trigger: risk_trigger,
  matching_type: 'exact'
)
