module BingAdsSimpleApi
  class Campaign < Base
    attr_reader :attributes
    attributes :name, :description, :bidding_scheme, :budget_type,
      :forward_compatibility_map, :status, :sub_type, :time_zone,
      :tracking_url_template, :url_custom_parameters, :campaign_type,
      :settings, :languages
    int_attributes :id, :budget_id, :audience_ads_bid_adjustment

    def initialize(hash)
      @attributes = hash
    end

    def self.find(*id_or_ids)
      campaigns = service.get_campaigns_by_ids(account_id, id_or_ids.flatten)
      campaigns = Array(campaigns).map{ |a| self.new(a) }
      id_or_ids.is_a?(Array) ? campaigns : campaigns.first
    end

    def self.all(*types)
      campaigns = service.get_campaigns_by_account_id(account_id, types)
      Array(campaigns).map{ |a| self.new(a) }
    end

    def self.account_id
      account_id = BingAdsSimpleApi.customer_account_id
    end
  end
end
