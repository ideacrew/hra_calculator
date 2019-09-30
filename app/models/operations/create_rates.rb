require Rails.root.join('lib', 'tasks', 'parsers', 'plan_rate_group_parser')
require Rails.root.join('lib', 'tasks', 'parsers', 'plan_rate_group_list_parser')

module Operations
  class CreateRates
    include Dry::Transaction::Operation

    def call(rates_params)
      begin
        files = [rates_params[:rates_file]]
        year = rates_params[:year].to_i
        tenant = rates_params[:tenant]
        rate_import_hash = files.inject(::ObjectBuilders::RateBuilder.new({tenant: tenant})) do |rate_hash, file|
          xml = Nokogiri::XML(File.open(file))
          rates = if year < 2018
            Parser::PlanRateGroupParser.parse(xml.root.canonicalize, :single => true)
          else
            Parser::PlanRateGroupListParser.parse(xml.root.canonicalize, :single => true)
          end
          rate_hash.add(rates.to_hash, "new", year)
          rate_hash
        end

        rate_import_hash.run
        Success('Created Rates for given data')
      rescue
        Failure('Unable to create rates for given data')
      end
    end
  end
end
