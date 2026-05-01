require 'json_api_responders/config'

module JsonApiResponders
  module Errors
    class UnknownHTTPStatus < StandardError
      attr_reader :status

      def initialize(status)
        @status = status
        super(message)
      end

      def message
        status_symbols =
          Rack::Utils::SYMBOL_TO_STATUS_CODE.keys.map(&:to_s)
        status_codes =
          Rack::Utils::SYMBOL_TO_STATUS_CODE.invert.keys.map(&:to_s)
        statuses = (status_symbols + status_codes).join(', ')

        "Unknown HTTP status code '#{status}'.\n"\
        "Available status codes and symbols are: #{statuses}"
      end
    end

    class RequiredOptionMissingError < StandardError
      attr_reader :required_option

      def initialize(required_option)
        @required_option = required_option
        super(message)
      end

      def message
        "Option '#{required_option}' is missing."
      end
    end

    class InvalidRenderMethodError < StandardError
      attr_reader :render_method

      def initialize(render_method)
        @render_method = render_method
        super(message)
      end

      def message
        "#{render_method} render method is invalid, must be one of: #{JsonApiResponders::Config::RENDER_METHODS}"
      end
    end

    class UnknownAction < StandardError
      attr_reader :action

      def initialize(action)
        @action = action
        super(message)
      end

      def message
        "Unknown controller action '#{action}'.\n"\
        "Accepted actions are #{JsonApiResponders::Responder::ACTIONS.join(', ')}"
      end
    end

    class StatusNotDefined < StandardError
      def message
        'Status is not defined'
      end
    end

    class InvalidDatabaseAdapterError < StandardError
      attr_reader :adapter

      def initialize(adapter)
        @adapter = adapter
        super(message)
      end

      def message
        "Unknown database adapter '#{adapter}'.\n"\
        "Accepted adapters are #{JsonApiResponders::Config::ADAPTERS.join(', ')}"
      end
    end
  end
end
