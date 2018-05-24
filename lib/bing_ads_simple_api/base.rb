module BingAdsSimpleApi
  class Base
    def self.attributes(*attribute_names)
      attribute_names.each do |name|
        define_method(name) do
          attributes[name]
        end
      end
    end

    def self.int_attributes(*attribute_names)
      attribute_names.each do |name|
        define_method(name) do
          attributes[name].nil? ? nil : attributes[name].to_i
        end
      end
    end

    def service
      self.class.service
    end

    def self.service
      @service ||= Services::CampaignManagement.new()
    end

  end
end
