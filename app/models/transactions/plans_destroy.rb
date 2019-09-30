module Transactions
  class PlansDestroy
    include Dry::Transaction

    step :fetch
    step :destroy

    private

    def fetch(input)
      @tenant = ::Tenants::Tenant.find(input[:id])

      if @tenant.blank?
        Failure({errors: {tenant_id: "Unabled to find tenant record with id #{input[:id]}"}})
      else
        Success({:state => @tenant.key.to_s.upcase})
      end
    end

    def destroy(input)
      service_area_ids = ::Locations::ServiceArea.where(covered_states: [input[:state]]).pluck(:id)
      ::Products::Product.where(:"service_area_id".in => service_area_ids).destroy_all

      Success('Process done')
    end
  end
end
