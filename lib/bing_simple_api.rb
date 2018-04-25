module BingSimpleApi
  def self.bing_authentication=(auth)
    @bing_authentication = auth
  end

  def self.bing_authentication
    @bing_authentication or raise "Bing not configured"
  end

end

require 'bing_simple_api/version'
