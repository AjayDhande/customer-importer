require 'rails_helper'

RSpec.describe Customer do
  describe "#get_code" do
    it "should convert country name to country code" do
    	country_code = Customer.get_code("India")
      expect(country_code).to eql("IN")
    end
    it "should give nil if country name is invalid" do
    	country_code = Customer.get_code("Indi")
      expect(country_code).to eql(nil)
    end
  end
end