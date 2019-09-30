module EnterpriseHash
  class TenantHash

    {:tenants=>
      [{:key=>:ic,
        :owner_organization_name=>"Ideacrew",
        :sites=>
         [{:key=>:primary,
           :title=>"HRA Affordability Tool",
           :description=>"This tool will help you determine how an HRA you're offered affects your eligibility for a tax credit and what to do next",
           :options=>
            [{:key=>:settings,
              :settings=>
               [{:key=>:marketplace_name,
                 :default=>"My Health Connector",
                 :description=>"The Marketplace Name will appear on the Tool header and embedded in text wherever the following token is entered: %marketplace_name%",
                 :type=>"string"},
                {:key=>:marketplace_website_url,
                 :default=>"https://openhbx.org",
                 :description=>"The Marketplace Website URL will appear on the Tool header and embedded in text wherever the following token is entered: %marketplace_website_url%",
                 :type=>:url},
                {:key=>:call_center_phone,
                 :default=>"1-800-555-1212",
                 :description=>"The Call Center Phone will appear on the Tool header and embedded in text wherever the following token is entered: %call_center_phone%",
                 :type=>"phone"}]},
             {:key=>:branding,
              :settings=>
               [{:key=>:site_logo, :description=>"Google offers an extensive catalog of open source fonts that may be used with the Tool.  See https://fonts.google.com/", :type=>:base_64, :default=>"nil"},
                {:key=>:fav_icon, :description=>"Google offers an extensive catalog of open source fonts that may be used with the Tool.  See https://fonts.google.com/", :type=>:base_64, :default=>"nil"}]},
             {:key=>:ui_theme,
              :settings=>
               [{:key=>"typefaces",
                 :description=>"Google offers an extensive catalog of open source fonts that may be used with the Tool.  See https://fonts.google.com/",
                 :type=>:array,
                 :default=>["https://fonts.googleapis.com/css?family=Lato:400,700,400italic"]}],
              :namespaces=>
               [{:key=>:bootstrap_pallette,
                 :settings=>
                  [{:key=>:primary_color, :type=>:swatch, :default=>"#007bff"},
                   {:key=>:secondary_color, :type=>:swatch, :default=>"#6c757d"},
                   {:key=>:success_color, :type=>:swatch, :default=>"#28a745"},
                   {:key=>:danger_color, :type=>:swatch, :default=>"#dc3545"},
                   {:key=>:warning_color, :type=>:swatch, :default=>"#ffc107"},
                   {:key=>:info_color, :type=>:swatch, :default=>"#17a2b8"}]}]}],
           :environments=>
            [{:key=>:production,
              :features=>
               [{:key=>:hra_affordability_tool,
                 :is_required=>true,
                 :is_enabled=>true,
                 :title=>"Silver Plan Criteria",
                 :description=>"Settings used to select and rate QHPs",
                 :options=>
                  [{:key=>:silver_plan_criteria,
                    :settings=>
                     [{:key=>:use_age_ratings,
                       :title=>"Use Age Ratings?",
                       :options=>[{true=>"Age Ratings"}, {false=>"No Age Ratings"}],
                       :type=>:radio_select,
                       :description=>"Choose whether your organization uses the member's age to determine health insurance premium rates.  If Yes, the Tool will collect the users date-of-birth to calculate premiums.",
                       :default=>:yes},
                      {:key=>:qsehra_premium_factor,
                       :title=>"Premium Value Used for QSEHRA Comparison",
                       :options=>[{:full=>"Full Premium"}, {:ehb=>"EHB Premium"}],
                       :description=>"QSEHRA determinations can use either the Second Lowest Cost Silver Plan's full premium or Essential Health Benefits value",
                       :default=>:full,
                       :type=>:radio_select},
                      {:key=>:rating_area_model,
                       :title=>"Geographic Rating Area Model",
                       :default=>"nil",
                       :type=>:radio_select,
                       :options=>[{:single=>"Single Rating Area"}, {:county=>"County-based Rating Area"}, {:zipcode=>"Zipcode-based Rating Area"}],
                       :description=>
                        "Choose boundaries that your organization uses to determine health insurance premium rates.  Single Rating Area requires SERFF template uploads only and will not ask the user for home residence information.  County- and Zipcode-based Rating Areas require SERFF templates plus County/Zip lookup table uploads and request the user enter county name and zip code as appropriate to calculate premiums."}]}]}]}]}]}]}

  end
end
                