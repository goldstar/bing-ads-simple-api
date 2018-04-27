require 'bing_ads_simple_api/exceptions'
require 'bing_ads_simple_api/helpers'
require 'bing_ads_simple_api/reports'
require 'bing_ads_simple_api/service'
require 'bing_ads_simple_api/version'
require 'net/http'
require 'json'
require 'uri'

module BingAdsSimpleApi
  include Helpers

  def self.authentication=(auth)
    # Pull out the refresh parameters
    @refresh_token = auth.delete(:refresh_token)
    @client_id = auth.delete(:client_id)
    @customer_account_id = auth[:customer_account_id]
    auth[:authentication_token] ||= refresh_authentication_token
    @authentication = tns(auth)
  end

  def self.authentication
    @authentication or raise "Bing not configured"
  end

  def self.customer_account_id
    @customer_account_id
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new($stdout)
  end

  def self.refresh_authentication_token
    uri = URI('https://login.live.com/oauth20_token.srf')
    response = Net::HTTP.post_form(uri,
      client_id:    @client_id,
      grant_type:   'refresh_token',
      refresh_token: @refresh_token,
      redirect_uri: "https://login.live.com/oauth20_desktop.srf"
    )
    authorization = JSON.parse(response.body)
    authorization['access_token'] or RefreshAuthenticationTokenError.new(response.body)
  end

end
