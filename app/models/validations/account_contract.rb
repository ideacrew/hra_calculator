module Validations
  class AccountContract < ::Dry::Validation::Contract
    params do
      required(:email).filled(:string)
      optional(:role).filled(:string)
    end
    # TODO: Add additional rules for email and role
  end
end
