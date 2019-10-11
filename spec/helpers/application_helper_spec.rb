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
        "<input type=\"text\" value=\"My Health Connector\" id=\"marketplace_name\" name=\"input_text[value]\" class=\"form-control\" required=\"required\">"
        # "<div class="form-group">
        #   <label for="exampleFormControlInput1">Email address</label>
        #   <input type="email" class="form-control" id="exampleFormControlInput1">
        # </div>"
      }

      let(:form){double("test", :object_name => "input_text")}

    it "should generate valid html for bootstrap input text control" do
      expect(helper.input_text_control(setting, form)).to eq input_text_control_html
    end
  end

  describe '#input_color_control' do
    let(:setting) { {:key=>:primary_color, :type=>:swatch, :default=>"#007bff"} }

    let(:input_color_control_html) { "<input type=\"color\" value=\"#007bff\" id=\"primary_color\">" }

    it 'should generate valid html for bootstrap color input control' do
      expect(helper.input_color_control(setting)).to eq input_color_control_html
    end
  end

  describe '#input_swatch_control' do
    let(:setting) { {:key=>:primary_color, :type=>:swatch, :default=>"#007bff"} }

    let(:input_swatch_control_html) { "<input type=\"text\" value=\"#007bff\" id=\"primary_color\" name=\"swatch_object[value]\" class=\"js-color-swatch form-control\"><div class=\"input-group-append\"><button type=\"button\" id=\"primary_color\" class=\"btn\" value=\"\" style=\"background-color: #007bff\"></button></div>" }

    let(:form){double("test", :object_name => "swatch_object")}

    it 'should generate valid html for input swatch control' do
      expect(helper.input_swatch_control(setting, form)).to eq input_swatch_control_html
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

    let(:radio_group_html) { "<div class=\"form-group\"><label for=\"qsehra_premium_factor\" value=\"Premium Value Used for QSEHRA Comparison\" aria-label=\"Radio button for following text input\">Premium Value Used for QSEHRA Comparison</label>control<small id=\"qsehra_premium_factorHelpBlock\" class=\"form-text text-muted\">QSEHRA determinations can use either the Second Lowest Cost Silver Plan&#39;s...</small></div>" }

    it 'should generate valid html for bootstrap radio group' do
      expect(helper.radio_form_group(setting, "control")).to eq radio_group_html
    end

  end

  describe "#input_currency_control" do
    let(:setting) { 
                    {
                        key: :marketplace_website_url,
                        default: "https://openhbx.org",
                        description: "The Marketplace Website URL will appear on the Tool header and embedded in text wherever the following token is entered: %marketplace_website_url%",
                        type: :url 
                      }
                    }
    let(:html_result) { "<div class=\"input-group-prepend\"><span class=\"input-group-text\">$</span></div><input type=\"text\" value=\"https://openhbx.org\" id=\"marketplace_website_url\" class=\"form-control\" aria-map=\"{&quot;label&quot;:&quot;Amount (to the nearest dollar)&quot;}\"><div class=\"input-group-append\"><span class=\"input-group-text\">.00</span></div>" }

    it "should generate valid bootstrap form_group & currency input group html" do
      expect(helper.input_currency_control(setting)).to eq html_result
    end
  end

  describe "#build_radio_form_group" do
    let(:feature_setting) { 
                    {
                        key: :use_age_ratings,
                        default: true,
                        description: "Choose whether your organization uses the member's age to determine health insurance premium rates.  If Yes, the Tool will collect the users date-of-birth to calculate premiums.",
                        type: :boolean 
                      }
                    }
    let(:html_result) { "<div class=\"form-group\"><label for=\"use_age_ratings\" value=\"Use Age Ratings\" aria-label=\"Radio button for following text input\">Use Age Ratings</label>radio<small id=\"use_age_ratingsHelpBlock\" class=\"form-text text-muted\">Choose whether your organization uses the member&#39;s age to determine health insurance premium rates.  If Yes, the Tool will collect the users date-of-birth to calculate premiums.</small></div>" }

    it "should generate valid bootstrap form_group & currency input group html" do
      expect(helper.radio_form_group(feature_setting, "radio")).to eq html_result
    end
  end

end