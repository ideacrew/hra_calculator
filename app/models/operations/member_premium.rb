module Operations
  class MemberPremium
    include Dry::Transaction::Operation

    def call(hra_object)
      age = ::Operations::AgeOn.new.call(hra_object).success
      rating_area = ::Locations::Operations::SearchForRatingArea.new.call(hra_object).success
      service_area = ::Locations::Operations::SearchForServiceArea.new.call(hra_object).success
      products = ::Products::Operations::FetchProducts.new.call({rating_area_id: rating_area.id, service_area_id: service_area.id, date: hra_object.start_month, age: age}).success
      low_cost_product_cost = ::Products::Operations::LowCostReferencePlanCost.new.call({products: products, age: age, hra_object: hra_object}).success
      Success(low_cost_product_cost)
    end
  end
end
