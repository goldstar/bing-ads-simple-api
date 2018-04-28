require 'date'

module BingAdsSimpleApi
  module Reports
    class DailyAdPerformanceReport < Base
      include Helpers

      # https://docs.microsoft.com/en-us/bingads/reporting-service/submitgeneratereport?view=bingads-12
      report_type 'AdPerformance'
      report_definition(
        report_name: 'Ad Performance Report',
        return_only_complete_data: 'true',
        aggregation: 'Daily',
        columns: %w[AdId TimePeriod AdGroupId AdGroupName CampaignId
          CampaignName Impressions Clicks Conversions Spend FinalUrl],
        time: {
          custom_date_range_end: Date.today-1,
          custom_date_range_start: Date.today-1
        }
      )

      date_columns(:time_period)
      integer_columns(:ad_id, :ad_group_id, :campaign_id, :impressions, :clicks)
      float_columns(:conversions, :spend)
    end
  end
end
