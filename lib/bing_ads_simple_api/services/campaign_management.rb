module BingAdsSimpleApi
  module Services
    class CampaignManagement < Base

      include Helpers

      def wsdl
        "https://campaign.api.bingads.microsoft.com/Api/Advertiser/CampaignManagement/v13/CampaignManagementService.svc?singleWsdl"
      end


      def get_ad_groups_by_campaign_id(campaign_id)
        response = client.call(
          :get_ad_groups_by_campaign_id,
          message: tns(
            campaign_id: campaign_id
          )
        ) # call
        # dig(response.body, :campaign)
      end

      def get_campaigns_by_account_id(account_id, types = nil)
        types = Array(types).map{|t| camelize(t) }
        response = client.call(
          :get_campaigns_by_account_id,
          message: tns(
            account_id: account_id,
            campaign_type: types
          )
        ) # call
        dig(response.body, :campaign)
      end

      def get_campaigns_by_ids(account_id, ids)
        ids = Array(ids).map{|t| t.to_i }
        response = client.call(
          :get_campaigns_by_ids,
          message: tns(
            account_id: account_id,
            campaign_ids: { 'a1:long' => ids }
          )
        ) # call
        # dig(response.body, :campaign)
      end


    end
  end
end
