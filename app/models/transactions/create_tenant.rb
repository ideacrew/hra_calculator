module Transactions
  class CreateTenant
    include Dry::Transaction

    step :merge
    step :validate
    step :persist
  end
end