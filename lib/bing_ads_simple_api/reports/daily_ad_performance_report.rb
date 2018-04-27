module BingAdsSimpleApi
  module Reports
    class DailyAdPerformanceReport < Base


# https://docs.microsoft.com/en-us/bingads/reporting-service/submitgeneratereport?view=bingads-12

      def report_attributes
        {
          "tns:ReportRequest" => {
            "i:type" => "tns:AdPerformanceReportRequest",
            "i:nil" => 'false'
          }
        }
      end

      def report_definition
        {
          format: 'Csv',
          language: 'English',
          # report_type: 'AdPerformance',
          report_name: 'MyReport',
          return_only_complete_data: 'false',
          aggregation: 'Daily',
          columns: {
            :ad_performance_report_column => %w[AdId TimePeriod AdGroupId AdGroupName CampaignId CampaignName Impressions Clicks Conversions Spend FinalUrl]
          },
          scope: {
            :account_ids => {
              'arr:long' => BingAdsSimpleApi.customer_account_id
            }
          },
          time: {
            custom_date_range_end: Date.yesterday,
            custom_date_range_start: Date.yesterday
          }
        }

      end


    end
  end
end
