module Products::Operations
  class LowCostReferencePlanCost
    include Dry::Transaction::Operation

    def call(hash_obj)
      products = hash_obj[:products]
      age = hash_obj[:age]
      hra_type = hash_obj[:hra_object].hra_type
      date = hash_obj[:hra_object].start_month.date
      member_premiums = products.inject([]) do |premiums, product|
        pt = product.premium_tables.where(:rating_area_id => rating_area_id, :"effective_period.min".lte => date).first
        premiums << pt.premium_tuples.where(age: age).first.cost
        premiums.flatten.compact
      end
      premiums = member_premiums.sort
      cost = hra_type.to_s.downcase == 'ichra' ? premiums.first : premiums.second
      Success(cost)
    end
  end
end
