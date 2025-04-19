Rails.application.reloader.to_prepare do
  Lumen.const_set :SETTINGS, LumenSetting.all rescue nil
  Lumen.const_set :UNKNOWN_WORK, Work.unknown rescue nil
end
Lumen.const_set :TRUNCATION_TOKEN_URLS_ACTIVE_PERIOD, 24.hours
Lumen.const_set :REDACTION_MASK, '[REDACTED]'.freeze
Lumen.const_set :OTHER_TOPIC, 'Uncategorized'.freeze
Lumen.const_set :TYPES_TO_TOPICS, {
  'Request' => 'Request',
  'Ban' => 'Ban',
  'Takedown' => 'Takedown',
  'Counternotice' => 'Appeal',
  'Response' => 'Response',
}.freeze
Lumen.const_set :TYPES, Lumen::TYPES_TO_TOPICS.keys
Lumen.const_set :TOPICS, Lumen::TYPES_TO_TOPICS.values
