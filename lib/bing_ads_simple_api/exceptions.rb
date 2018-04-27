module BingAdsSimpleApi
  class AuthenticationTokenExpiredError < StandardError; end
  class ReportUrlGenerationErrorError < StandardError; end
  class ReportUrlNotFoundError < StandardError; end
  class RefreshAuthenticationTokenError < StandardError; end
end
