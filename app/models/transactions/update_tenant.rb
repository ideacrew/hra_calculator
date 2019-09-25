module Transactions
  class UpdateTenant
    include Dry::Transaction

    step :merge
    step :validate
    step :persist
  end
end