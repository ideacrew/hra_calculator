module Products::Operations
  class LowCostReferencePlanCost
    include Dry::Transaction::Operation

    def call(hash_obj)
      products = hash_obj[:products]
      hra_object = hash_obj[:hra_object]
      hra_type = hra_object.hra_type
      date = hra_object.start_month
      age = ::Operations::AgeLookup.new.call(hra_object.age).success

      member_premiums = products.inject([]) do |premiums, product|
        begin
          premium_tables = product.premium_tables.where(:rating_area_id => hra_object.rating_area_id).effective_period_cover(date)
          premium_tables.each do |premium_table|
            premiums << premium_table.premium_tuples.where(age: age).first.cost
            premiums
          end
          premiums
        rescue
          premiums
        end
        premiums.flatten.compact
      end

      if member_premiums.empty?
        hra_object.errors << 'Could Not find any member premiums for the given data'
        Failure(hra_object)
      else
        final_premium_set = member_premiums.sort
        cost = hra_type.to_s.downcase == 'ichra' ? final_premium_set.first : final_premium_set.second
        Success(cost)
      end
    end
  end
end
