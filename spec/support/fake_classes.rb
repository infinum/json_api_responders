module ActiveRecord
  class RecordNotFound < StandardError
  end
end

module Mongoid
  module Errors
    class DocumentNotFound < StandardError
    end
  end
end

module ActionController
  class ParameterMissing
  end
end

class FakeController
  def self.rescue_from(*_args)
  end

  include JsonApiResponders

  def params
    {}
  end
end

class FakeModel
  include ActiveModel::Model

  def errors
    @errors ||= super.tap do |errors|
      errors.add(:name, "can't be blank")
    end
  end
end

module I18n
  def self.t(translation, *args)
    translation
  end
end

module ActiveModel
  class Errors
    def full_message(attribute, message)
      "#{attribute.to_s.humanize} #{message}"
    end
  end
end
