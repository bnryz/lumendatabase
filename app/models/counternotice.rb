# frozen_string_literal: true

class Counternotice < Notice
  DEFAULT_ENTITY_NOTICE_ROLES = (%w[recipient sender]).freeze

  load_elasticsearch_helpers

  validates :title, length: { maximum: 255 }

  def self.model_name
    Notice.model_name
  end

  def self.label
    'Appeal'
  end

  def to_partial_path
    'notices/notice'
  end
end
