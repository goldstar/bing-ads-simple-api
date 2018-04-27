module BingAdsSimpleApi
  class Foo
    include Helpers
  end
end

RSpec.describe BingAdsSimpleApi::Helpers do
  let(:klass){ BingAdsSimpleApi::Foo }
  let(:instance){ BingAdsSimpleApi::Foo.new }

  describe "camelize" do
    it "should camelize on class" do
      expect(klass.camelize(:hello_world)).to eq('HelloWorld')
    end
    it "should camelize on instance" do
      expect(instance.camelize(:hello_world)).to eq('HelloWorld')
    end
  end

  describe "tns" do
    it "should transform hash keys into tns keys" do
      expect(
        klass.tns({hello_world: 1})
      ).to eq({'tns:HelloWorld' => 1})
    end
  end
end
