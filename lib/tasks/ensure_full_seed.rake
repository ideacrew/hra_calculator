namespace :db do
  desc "Ensure the full seed data has been loaded"
  task :ensure_full_seed => :environment do
    enterprise = Enterprises::Enterprise.where(owner_organization_name: 'OpenHBX').first
    if enterprise
      ResourceRegistry::AppSettings[:options].each do |option_hash|
        if option_hash[:key] == :benefit_years
          option = Options::Option.new(option_hash)
      
          option.child_options.each do |setting|
            existing_benefit_year = Enterprises::BenefitYear.where(
              calendar_year: setting.key.to_s.to_i,
              enterprise_id: enterprise.id
            ).first
            unless existing_benefit_year
              enterprise.benefit_years.create({ expected_contribution: setting.default, calendar_year: setting.key.to_s.to_i, description: setting.description })
            end
          end
        end
      end
    else
      Rake::Task["db:seed"].invoke
    end
  end
end