module BingAdsSimpleApi
  module Reports
    class Base
      SUCCESS = 'Success'
      ERROR = 'Error'

      include Helpers
      attr_reader :request_id

      

      def service
        @service ||= begin
          wsdl = "https://reporting.api.bingads.microsoft.com/Api/Advertiser/Reporting/V12/ReportingService.svc?singleWsdl"
          BingAdsSimpleApi::Service.new(wsdl)
        end
      end

      def submit_generate_report
        response = service.call(
          :submit_generate_report,
          message:
            tns(report_request: report_definition).merge(
              :attributes! => report_attributes
            ) # merge
        ) # call
        @request_id = dig(response.body, :report_request_id)
      end

      def poll_generate_report
        response = service.call(
          :poll_generate_report, message: tns(
              report_request_id: request_id
          )
        )
        status = dig(response.body, :status)
        if status == SUCCESS
          download_url = dig(response.body, :report_download_url)
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
