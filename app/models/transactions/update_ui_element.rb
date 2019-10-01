module Transactions
  class UpdateUiElement

    include Dry::Transaction(container: ::Registry)

    step :fetch
    step :persist

    private

    def fetch(input)
      @tenant = Tenants::Tenant.find(input[:tenant_id])

      if @tenant.blank?
        Failure({errors: {tenant_id: "Unabled to find tenant record with id #{input[:id]}"}})
      else
        Success(input[:ui_element])
      end
    end

    def persist(input)
      re = /<("[^"]*"|'[^']*'|[^'">])*>/
      if @tenant.sites[0].options.where(key: :ui_tool_pages).first.child_options.find(input[:option_id]).update_attributes(value: input[:option][:default].gsub(re, ''))
        Success(@tenant)
      else
        Failure(@tenant)
      end
    end
  end
end