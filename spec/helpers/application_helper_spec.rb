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
  end

  describe "#build_radio_input_group" do
    let(:feature_setting) { 
                    {
                        key: :use_age_ratings,
                        default: true,
                        description: "Choose whether your organization uses the member's age to determine health insurance premium rates.  If Yes, the Tool will collect the users date-of-birth to calculate premiums.",
                        type: :boolean 
                      }
                    }
    let(:html_result) {
      "<div class=\"form-group\"><label for=\"marketplace_website_url\" value=\"Marketplace Website Url\"></label><div class=\"input-group\"><div class=\"input-group-prepend\"><span class=\"input-group-text\">$</span></div><input value=\"https://openhbx.org\" type=\"text\" class=\"form-control\" aria-label=\"Amount (to the nearest dollar)\"><div class=\"input-group-append\"><span class=\"input-group-text\">.00</span></div></div><small id=\"marketplace_website_urlHelpBlock\" class=\"form-text text-muted\">The Marketplace Website URL will appear on the Tool header and embedded in text wherever the following token is entered: %marketplace_website_url%</small></div>"
    }

    it "should generate valid bootstrap form_group & currency input group html" do
      expect(helper.build_currency_input_group(setting)).to eq html_result
    end
  end

end