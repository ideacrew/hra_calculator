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
      ::Locations::RatingArea.all.where(covered_states: [state_abbr]).destroy_all
      ::Locations::ServiceArea.all.where(covered_states: [state_abbr]).destroy_all
      ::Locations::CountyZip.all.where(state: state_abbr).destroy_all
      Success('Process done')
    end
  end
end
