require 'savon'
require 'bing_ads_simple_api/helpers'

module BingAdsSimpleApi
  module Services
    class Base
      include Helpers

      attr_reader :logger, :client

      def initialize
        @logger ||= BingAdsSimpleApi.logger
        @client = Savon.client(
          wsdl:        wsdl,
          soap_header: BingAdsSimpleApi.authentication,
          log_level:  :debug,
          log: true,
          pretty_print_xml: true,
          namespaces: {
            'xmlns:arr' => 'http://schemas.microsoft.com/2003/10/Serialization/Arrays',
            'xmlns:i'   => 'http://www.w3.org/2001/XMLSchema-instance'
          }
        )
      end

      def call(action, options)
        begin
          response = client.call(action, options)
        rescue Savon::SOAPFault => e
          if error = dig(e.to_hash, :ad_api_error) || dig(e.to_hash, :operation_error)
            error_code = error[:error_code]
            message = error[:message]
            if error_code == 'AuthenticationTokenExpired'
              logger.error error_code
              raise AuthenticationTokenExpiredError.new(message)
            end
          end
          logger.error e.message
          raise e
        end
        response
      end
    end
  end
end
