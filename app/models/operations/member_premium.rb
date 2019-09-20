module Operations
  class MemberPremium
    include Dry::Transaction::Operation

    def call(hra_object)
      hra_object.age = ::Operations::AgeOn.new.call(hra_object).success
      hra_object.rating_area_id = ::Locations::Operations::SearchForRatingArea.new.call(hra_object).success.id.to_s
      hra_object.service_area_ids = ::Locations::Operations::SearchForServiceArea.new.call(hra_object).success.pluck(:id).map(&:to_s)
      products = ::Products::Operations::FetchProducts.new.call(hra_object).success
      low_cost_product_cost = ::Products::Operations::LowCostReferencePlanCost.new.call({products: products, hra_object: hra_object}).success
      Success(low_cost_product_cost)
    end
  end
end
