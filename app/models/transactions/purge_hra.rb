module Transactions
  class PurgeHra
    include Dry::Transaction

    step :fetch
    step :destroy

    private

    def fetch
      @tenants = ::Tenants::Tenant.all

      if @tenants.blank?
        Failure({errors: "There are no tenants."})
      else
        Success(@tenants)
      end
    end

    def destroy(input)
      ::Products::Product.all.destroy_all
      ::Locations::ServiceArea.all.destroy_all
      ::Locations::RatingArea.all.destroy_all
      ::Locations::CountyZip.all.destroy_all
      input.destroy_all
      Success('Process done')
    end
  end
end
