module BingAdsSimpleApi
  module Services
    class Reporting < Base

      SUCCESS = 'Success'
      ERROR = 'Error'

      include Helpers

      def wsdl
        "https://reporting.api.bingads.microsoft.com/Api/Advertiser/Reporting/V13/ReportingService.svc?singleWsdl"
      end

      def submit_generate_report(message)
        response = client.call(
          :submit_generate_report,
          message: message
        ) # call
        dig(response.body, :report_request_id)
      end

      def poll_generate_report(request_id)
        response = client.call(
          :poll_generate_report, message: tns(
              report_request_id: request_id
          )
        )
        status = dig(response.body, :status)
        if status == SUCCESS
          download_url = dig(response.body, :report_download_url)
          # This can mean that the report was empty
          raise ReportUrlNotFoundError.new(response.body.to_s) if download_url.nil?
          return download_url
        elsif status == ERROR
          raise ReportUrlGenerationError.new(response.body.to_s)
        end
        nil
      end

    end
  end
end
