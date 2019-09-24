require "rails_helper"

RSpec.describe ApplicationHelper, :type => :helper do



  describe "#build_currency_input_group" do
    let(:setting) { 
                    {
                        key: :marketplace_website_url,
                        default: "https://openhbx.org",
                        description: "The Marketplace Website URL will appear on the Tool header and embedded in text wherever the following token is entered: %marketplace_website_url%",
                        type: :url 
                      }
                    }
    let(:html_result) {
      "<div class=\"form-group\"><label for=\"marketplace_website_url\" value=\"Marketplace Website Url\"></label><div class=\"input-group\"><div class=\"input-group-prepend\"><span class=\"input-group-text\">$</span></div><input value=\"https://openhbx.org\" type=\"text\" class=\"form-control\" aria-label=\"Amount (to the nearest dollar)\"><div class=\"input-group-append\"><span class=\"input-group-text\">.00</span></div></div><small id=\"marketplace_website_urlHelpBlock\" class=\"form-text text-muted\">The Marketplace Website URL will appear on the Tool header and embedded in text wherever the following token is entered: %marketplace_website_url%</small></div>"
    }

    it "should generate valid bootstrap form_group & currency input group html" do
      expect(helper.build_currency_input_group(setting)).to eq html_result
    end

    # it "should return blocking when true" do
    #   allow(employer_profile).to receive(:applicant?).and_return(true)
    #   allow(Plan).to receive(:has_rates_for_all_carriers?).and_return(false)
    #   expect(helper.rates_available?(employer_profile)).to eq "blocking"
    # end

    # it "should return empty string when false" do
    #   allow(employer_profile).to receive(:applicant?).and_return(false)
    #   expect(helper.rates_available?(employer_profile)).to eq ""
    # end
  end

end