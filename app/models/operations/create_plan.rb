require Rails.root.join('lib', 'tasks', 'parsers', 'plan_benefit_template_parser')

module Operations
  class CreatePlan
    include Dry::Transaction::Operation

    def call(plan_params)
      begin
        files = [plan_params[:plans_file]]
        year = plan_params[:year]
        qhp_import_product_hash = files.inject(::ObjectBuilders::PlanBuilder.new({tenant: plan_params[:tenant], import_timestamp: plan_params[:import_timestamp], carrier_name: plan_params[:carrier_name]})) do |qhp_product_hash, file|
          xml = Nokogiri::XML(File.open(file))
          product = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
          qhp_product_hash.add(product.to_hash)
          qhp_product_hash
        end

        qhp_import_product_hash.run

        Success('Created Plan for given data')
      rescue => e
        Failure('Unable to create Plan for given data')
      end
    end
  end
end
