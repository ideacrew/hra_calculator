module Transactions
  class StoreHraDetermination
    include Dry::Transaction

    step :fetch_params
    step :persist_hra_determination

    private

    def fetch_params(hash_input)
      params = hash_input[:hra_object].to_h
      params.merge!({ tenant_key: params[:tenant], state_name: params[:state], expected_contribution: hash_input[:expected_contribution] })
      params.slice!(:tenant_key, :state_name, :zipcode, :county, :dob, :household_frequency,
                   :household_amount, :hra_type, :start_month, :end_month, :hra_frequency,
                   :hra_amount, :member_premium, :age, :hra_cost, :hra_determination, :rating_area_id,
                   :service_area_ids, :expected_contribution)
      Success(params)
    end

    def persist_hra_determination(hra_params)
      ::HraDetermination.new(hra_params).save!
      Success('Created and Stored HraDetermination object')
    end
  end
end
