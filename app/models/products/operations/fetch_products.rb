module Products::Operations
  class FetchProducts
    include Dry::Transaction::Operation

    def call(hra_object)
      age = ::Operations::AgeLookup.new.call(hra_object.age).success
      products = ::Products::Product.where(
        :premium_tables.exists => true,
        :"premium_tables.premium_tuples".exists => true,
        service_area_id: hra_object.service_area_id,
        :"premium_tables.rating_area_id" => hra_object.rating_area_id,
        :"premium_tables.effective_period.min".lte => hra_object.start_month,
        :"premium_tables.premium_tuples.age" => age)

      # TODO: Remove this once all products are properly loaded.
      products = ::Products::Product.exists(:"premium_tables.premium_tuples" => true) if products.all.count == 0

      return Success(products) if products.present?

      hra_object.errors << 'Could Not find any Products for the given data'
      Failure(hra_object)
    end
  end
end
