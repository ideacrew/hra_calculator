module Transactions
  class PlansDestroy
    include Dry::Transaction

    step :fetch
    step :destroy

    private

    def fetch(input)
      @tenant = ::Tenants::Tenant.find(input[:id])

      if @tenant.blank?
        Failure({errors: {tenant_id: "Unable to find tenant record with id #{input[:id]}"}})
      else
        Success({:state => @tenant.key.to_s.upcase})
      end
    end

    def destroy(input)
      @tenant.products.destroy_all
      state_abbr = @tenant.key.to_s.upcase
      ::Locations::ServiceArea.all.destroy_all
      ::Locations::RatingArea.all.destroy_all
      ::Locations::CountyZip.all.destroy_all
      Success('Process done')
    end
  end
end
