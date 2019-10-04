require "rails_helper"

RSpec.describe Transactions::UpdateTenant, type: :model, dbclean: :after_each do

  let(:enterprise) {
    FactoryBot.create(:enterprise)
  }

  let(:tenant) {
    enterprise.tenants.create(ResourceRegistry::AppSettings[:tenants][0])
  }

  let(:params) {
    {
      "id" => tenant.id.to_s,
      "tenants_tenant" =>{
        "owner_organization_name"=>"DC Marketplace", 
        "sites_attributes"=>{
        "0"=>{
          "options_attributes"=>{
            "0"=>{
              "options_attributes" => {
                "0" => {
                    "key" => "marketplace_name",
                    "value" => "My Health Connector",
                    "id" => ''
                  },
                "1" => {
                    "key" => "marketplace_website_url",
                    "value" => "https://openhbx.org",
                    "id" => ''
                  },
              "id"=>"5d8f66743a9d8300017ad201"}}, 
            "1"=>{
              "typefaces"=>"[\"https://fonts.googleapis.com/css?family=Lato:400,700,400italic\"]", 
              "options_attributes"=>{
                "0" => {
                    "key" => "primary_color",
                    "value" => "#007bff",
                    "id" => ''
                  },
                "1" => {
                    "key" => "secondary_color",
                    "value" => "#6c757d",
                    "id" => '',
                  }, "id"=>"5d8f66743a9d8300017ad202"}}, 
        "id"=>"5d8f66743a9d8300017ad1f5"}
        }}
      }
    }.deep_symbolize_keys!
  }

  context "when valid params passed" do

    it 'should update tenant' do
      Transactions::UpdateTenant.new.call(params)
    end
  end
end