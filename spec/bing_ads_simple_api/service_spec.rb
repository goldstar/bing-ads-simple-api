RSpec.describe BingAdsSimpleApi::Service do
  before do
    BingAdsSimpleApi.authentication = {}
  end

  subject{ described_class.new("https://example.com/wsdl") }

  describe "initialize" do
    it "should create a savon client" do
      expect(subject.client).to be_a(Savon::Client)
    end
  end

end
