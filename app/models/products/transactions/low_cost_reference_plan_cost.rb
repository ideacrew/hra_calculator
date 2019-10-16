# frozen_string_literal: true

module Products::Transactions
  class LowCostReferencePlanCost
    include Dry::Transaction

    step :fetch_tenant
    step :calculate_actual_and_premium_ages
    step :fetch_member_premiums
    step :find_lcrp

    private

    def fetch_tenant(params)
      @tenant = Tenants::Tenant.find_by_key(params[:tenant])
      @hra_type = params[:hra_type]
      Success(params)
    end

    def calculate_actual_and_premium_ages(params)
      if @tenant.use_age_ratings == "age_rated"
        params.merge!({age: ::Operations::AgeOn.new.call(params).success})
        @premium_age = ::Operations::AgeLookup.new.call(params[:age]).success
      else
        params.merge!({age: nil})
      end
      params.merge!({premium_age: @premium_age})

      Success(params)
    end

    def fetch_member_premiums(params)
      member_premiums = params[:plans_query_criteria].inject([]) do |premiums_array, product|
        begin
          premium_tables = if (@tenant.geographic_rating_area_model != 'single')
            product.premium_tables.where(:rating_area_id => params[:rating_area_id]).effective_period_cover(params[:start_month])
          else
            product.premium_tables.effective_period_cover(params[:start_month])
          end

          premium_tables.each do |premium_table|
            if @tenant.use_age_ratings == "age_rated"
              pt = premium_table.premium_tuples.where(age: @premium_age).first
              premiums_array << [pt.cost, product.carrier_name, product.hios_id, product.title]
            elsif @tenant.use_age_ratings == "non_age_rated"
              pt = premium_table.premium_tuples.first
              premiums_array << [pt.cost, product.carrier_name, product.hios_id, product.title]
            end
            premiums_array
          end

          premiums_array
        rescue
          premiums_array
        end
        premiums_array.compact
      end

      Success({member_premiums: member_premiums, params: params})
    end

    def find_lcrp(input_hash)
      if input_hash[:member_premiums].empty?
        Failure({errors: ['Could Not find any member premiums for the given data']})
      else
        final_premium_set = input_hash[:member_premiums].uniq(&:first).sort_by{|mp| mp.first}
        product_details = if @hra_type.to_s.downcase == 'ichra'
                            final_premium_set.first + [::LowCostReferencePlan::Kinds.first]
                          else
                            (final_premium_set.second || final_premium_set.first) + [::LowCostReferencePlan::Kinds.second]
                          end
        input_hash[:params].merge!({member_premium: product_details.first, carrier_name: product_details[1],
          hios_id: product_details[2], plan_name: product_details[3], plan_kind: product_details[4]})

        Success(input_hash[:params])
      end
    end
  end
end
