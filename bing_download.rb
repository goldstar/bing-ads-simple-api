require 'bing-ads-reporting'
require 'datebox'
require 'savon'
require 'net/http'
require 'json'

redirect_uri = "https://login.live.com/oauth20_desktop.srf"
uri = URI('https://login.live.com/oauth20_token.srf')
refresh_token = "MCRhnIbGkL*fMnFz7ph*KbR3CAKM3GQhz8QGm*Q1pFDJ9BRGwNnT*pskMs45plzPy6oyrTodP2wSl7*UG*MnW52q07V2Rxie75BCBr0VTdZ2HUKbG73pED0E3LNjnHFgj8ND6AJdcGwTlF4r5R699SvCsXAGCpAmnhvly2q2s9FDvSaYbNgTJ*AZcs68JeLvTtrYIwhGpfvuVRjnY081CWFy6TyOpD1hqJ9!Y!39G5FGQoAbNmR2TR176WSjF5VwLtFFgP1bxpedf3o8Qdf2KpRJi2ty0hcJwdMlTyOqZHfyBdtxmX*2!I0M28KW0S3NQyCeGDN9NlHUukii5hAsB20E$"
client_id = "a85887f5-c4f6-4512-95d3-220cd8bff6ef"  # Registered Goldstar App's id

response = Net::HTTP.post_form(uri,
  client_id: client_id,
  grant_type: 'refresh_token',
  refresh_token: refresh_token,
  redirect_uri: redirect_uri
)

authorization = JSON.parse(response.body)
access_token = authorization['access_token']


service = BingAdsReporting::Service.new({
  authenticationToken: access_token, # Oauth authorization from above
  developerToken: '1112QAURG0365163',  # goldstarevents (rgraff@goldstar.com)
  accountId: '1075165',  # Goldstar
  customerId: '7028373'}) # Goldstar

# Report types:
# https://docs.microsoft.com/en-us/bingads/reporting-service/reporting-data-objects?view=bingads-12

period = Datebox::Period.new('2018-04-01', '2018-04-07')
# report_id = service.generate_report({
#   report_type: 'KeywordPerformance',
#   report_format: 'Tsv',
#   aggregation: 'Daily',
#   aggregation_period: 'ReportAggregation::Daily',
#   columns: %w[AccountId AccountName CampaignId CampaignName AdGroupId AdGroupName KeywordId Keyword DestinationUrl DeliveredMatchType AverageCpc CurrentMaxCpc AdDistribution CurrencyCode Impressions Clicks Ctr CostPerConversion Spend AveragePosition TimePeriod CampaignStatus AdGroupStatus DeviceType]
# }, {period: period})

report_id = service.generate_report({
  report_type: 'AdPerformance',
  report_format: 'Csv',
  include_headers: 'false',
  aggregation: 'Daily',
  aggregation_period: 'ReportAggregation::Daily',
  columns: %w[AdId TimePeriod AdGroupId AdGroupName CampaignId CampaignName Impressions Clicks Conversions Spend DisplayUrl]
}, {period: period})


until service.report_ready?(report_id)
  puts "."
  sleep 1
end

puts "Download here:"
puts service.send(:report_url, report_id)
