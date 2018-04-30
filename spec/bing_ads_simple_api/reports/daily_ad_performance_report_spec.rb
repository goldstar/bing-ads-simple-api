RSpec.describe BingAdsSimpleApi::Reports::DailyAdPerformanceReport do
  describe "report" do
    let(:report){
      described_class.new
    }
    let(:csv_string){
      [
        '"AdId","TimePeriod","AdGroupId","AdGroupName","CampaignId","CampaignName","Impressions","Clicks","Conversions","Spend","FinalUrl"',
        "123,2003-04-04,345,socal_4,1837091,z_s_geo_socal_5,10,4,2,1,https://www.goldstar.com",
        "124,2003-04-04,346,socal_5,1837091,z_s_geo_socal_5,12,6,3,2,https://www.goldstar.com",
      ].join("\n")
    }
    let(:result){ report.to_a.first }

    before :each do
      allow(report).to receive(:download).and_return(csv_string)
    end

    describe "perform" do
      it "should return an array" do
        expect(report.to_a).to be_an(Array)
      end
    end

    describe "a result" do
      it "should transfrom the values from strings" do
        expect(result[:campaign_id]).to eq(1837091)
        expect(result[:campaign_name]).to eq('z_s_geo_socal_5')
        expect(result[:time_period]).to eq(Date.new(2003,4,4))
        expect(result[:impressions]).to eq(10)
        expect(result[:clicks]).to eq(4)
        expect(result[:conversions]).to eq(2.0)
        expect(result[:spend]).to eq(1.0)
      end
    end
  end
end
