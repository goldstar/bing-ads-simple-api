require 'savon'
require 'bing_ads_simple_api/helpers'

module BingAdsSimpleApi
  class Service
    attr_reader :logger, :client

    def initialize(wsdl)
      @logger ||= BingAdsSimpleApi.logger
      @client = Savon.client(
        wsdl:        wsdl,
        soap_header: BingAdsSimpleApi.authentication,
        log_level:  :info,
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
        message = 'unexpected error'
        error = e.to_hash[:fault][:detail][:ad_api_fault_detail][:errors][:ad_api_error][:error_code] rescue nil
        message = e.to_hash[:fault][:detail][:ad_api_fault_detail][:errors][:ad_api_error][:message] if error
        if error.nil?
          error = e.to_hash[:fault][:detail][:api_fault_detail][:operation_errors][:operation_error][:error_code] rescue nil
          message = e.to_hash[:fault][:detail][:api_fault_detail][:operation_errors][:operation_error][:message] if error
        end
        if error == 'AuthenticationTokenExpired'
          logger.error error
          raise AuthenticationTokenExpiredError.new(message)
        end
        logger.error e.message
        logger.error message
        raise e
      end

      response
    end

  end
end
