# frozen_string_literal: true

module Products::Operations
  class LowCostReferencePlanCost
    include Dry::Transaction::Operation

    def call(params)
      tenant = Tenants::Tenant.find_by_key(params[:tenant])
      if tenant.use_age_ratings == "age_rated"
        params.merge!({age: ::Operations::AgeOn.new.call(params).success})
      else
        params.merge!({age: nil})
      end
      @premium_age = ::Operations::AgeLookup.new.call(params[:age]).success if tenant.use_age_ratings == 'age_rated'
      member_premiums = params[:plans_query_criteria].inject([]) do |premiums_array, product|
        begin
          premium_tables = unless (tenant.geographic_rating_area_model == 'single')
            product.premium_tables.where(:rating_area_id => params[:rating_area_id]).effective_period_cover(params[:start_month])
          else
            product.premium_tables.effective_period_cover(params[:start_month])
          end

          premium_tables.each do |premium_table|
            if tenant.use_age_ratings == "age_rated"
              pt = premium_table.premium_tuples.where(age: @premium_age).first
              premiums_array << [pt.cost, product.carrier_name, product.hios_id, product.title, @premium_age]
            elsif tenant.use_age_ratings == "non_age_rated"
              pt = premium_table.premium_tuples.first
              premiums_array << [pt.cost, product.carrier_name, product.hios_id, product.title, nil]
            end
            premiums_array
          end

          premiums_array
        rescue
          premiums_array
        end
        premiums_array.compact
      end

      if member_premiums.empty?
        Failure({errors: ['Could Not find any member premiums for the given data']})
      else
        final_premium_set = member_premiums.uniq(&:first).sort_by{|mp| mp.first}
        product_details = if params[:hra_type].to_s.downcase == 'ichra'
                            final_premium_set.first + [::LowCostReferencePlan::Kinds.first]
                          else
                            (final_premium_set.second || final_premium_set.first) + [::LowCostReferencePlan::Kinds.second]
                          end
        Success(product_details)
      end
    end
  end
end
