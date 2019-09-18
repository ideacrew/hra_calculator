module Operations
  class MemberPremium
    include Dry::Transaction::Operation

    def call(hra_object)
      hra_object.age = ::Operations::AgeOn.new.call(hra_object).success
      hra_object.rating_area_id = ::Locations::Operations::SearchForRatingArea.new.call(hra_object).success.id
      hra_object.service_area_id = ::Locations::Operations::SearchForServiceArea.new.call(hra_object).success.id
      products = ::Products::Operations::FetchProducts.new.call(hra_object).success
      low_cost_product_cost = ::Products::Operations::LowCostReferencePlanCost.new.call({products: products, hra_object: hra_object}).success
      Success(low_cost_product_cost)
    end
  end
end
