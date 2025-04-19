# frozen_string_literal: true

class Response < Notice
  DEFAULT_ENTITY_NOTICE_ROLES=(%w[recipient sender]).freeze

  load_elasticsearch_helpers

  def self.model_name
    Notice.model_name
  end

  def to_partial_path
    'notices/notice'
  end
end
