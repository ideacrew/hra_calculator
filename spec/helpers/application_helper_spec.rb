require "rails_helper"

RSpec.describe ApplicationHelper, :type => :helper do

  describe "#input_text_control" do
    let(:setting) { 
        {
          :key=>:marketplace_name, 
          :default=>"My Health Connector", 
          :description=>"The Marketplace Name will appear on the Tool header and embedded in text wherever the following token is entered: %marketplace_name%", 
          :type=>"string"
        } 
      }

    let(:input_text_control_html) {
        "<input type=\"text\" value=\"My Health Connector\" id=\"marketplace_name\" class=\"form-control\">"
        # "<div class="form-group">
        #   <label for="exampleFormControlInput1">Email address</label>
        #   <input type="email" class="form-control" id="exampleFormControlInput1">
        # </div>"
      }

    it "should generate valid html for bootstrap input text control" do
      expect(helper.input_text_control(setting)).to eq input_text_control_html
    end
  end

  describe '#input_color_control' do
    let(:setting) { {:key=>:primary_color, :type=>:swatch, :default=>"#007bff"} }

    let(:input_color_control_html) { "<div></div>" }

    it 'should generate valid html for bootstrap color input control' do
      expect(helper.input_color_control(setting)).to eq input_color_control_html
    end
  end

  describe '#input_swatch_control' do
    let(:setting) { {:key=>:primary_color, :type=>:swatch, :default=>"#007bff"} }

    let(:input_swatch_control_html) { "<div></div>" }

    it 'should generate valid html for input swatch control' do
      expect(helper.input_swatch_control(setting)).to eq input_color_control_html
    end
  end



  describe '#build_radio_group' do

    let(:setting) {
        {
          :key=>:qsehra_premium_factor,
          :title=>"Premium Value Used for QSEHRA Comparison",
          :options=>[{:full=>"Full Premium"}, {:ehb=>"EHB Premium"}],
          :description=>"QSEHRA determinations can use either the Second Lowest Cost Silver Plan's...",
          :default=>:full,
          :type=>:radio_select
        }
      }

    let(:settings)  {[
       {:key=>:primary_color, :type=>:swatch, :default=>"#007bff"},
       {:key=>:secondary_color, :type=>:swatch, :default=>"#6c757d"},
       {:key=>:success_color, :type=>:swatch, :default=>"#28a745"},
       {:key=>:danger_color, :type=>:swatch, :default=>"#dc3545"},
       {:key=>:warning_color, :type=>:swatch, :default=>"#ffc107"},
       {:key=>:info_color, :type=>:swatch, :default=>"#17a2b8"}
     ]
    }

    let(:radio_group_html) { "<div></div>" }

    it 'should generate valid html for bootstrap radio group' do
      expect(helper.build_radio_group(settings)).to eq radio_group_html
    end


  end



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