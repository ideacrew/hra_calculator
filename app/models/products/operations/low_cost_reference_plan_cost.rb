module Products::Operations
  class LowCostReferencePlanCost
    include Dry::Transaction::Operation

    def call(hash_obj)
      products = hash_obj[:products]
      hra_object = hash_obj[:hra_object]
      hra_type = hra_object.hra_type
      date = hra_object.start_month

      tenant = Tenants::Tenant.find_by_key(hra_object.tenant)

      member_premiums = products.inject([]) do |premiums_array, product|
        begin
          premium_tables = if ['zipcode'].include?(tenant.geographic_rating_area_model)
            product.premium_tables.where(:rating_area_id => hra_object.rating_area_id).effective_period_cover(date)
          else
            product.premium_tables.effective_period_cover(date)
          end

          premium_tables.each do |premium_table|
            if tenant.use_age_ratings == "age_rated"
              age = ::Operations::AgeLookup.new.call(hra_object.age).success
              pt = premium_table.premium_tuples.where(age: age).first
              premiums_array << [pt.cost, product.carrier_name, product.hios_id, product.title]
            elsif tenant.use_age_ratings == "non_age_rated"
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

      if member_premiums.empty?
        hra_object.errors += ['Could Not find any member premiums for the given data']
        Failure(hra_object)
      else
        final_premium_set = member_premiums.uniq(&:first).sort_by{|mp| mp.first}
        cost = hra_type.to_s.downcase == 'ichra' ? final_premium_set.first : (final_premium_set.second || final_premium_set.first)
        Success(cost)
      end
    end
  end
end
