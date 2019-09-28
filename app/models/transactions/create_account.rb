module Transactions
  class CreateAccount
    include Dry::Transaction

    step :validate
    step :persist

    private

    def validate(input)
      output = ::Validations::AccountContract.new.call(input)

      if output.failure?
        result = output.to_h
        result[:errors] = []
        output.errors.to_h.each_pair do |keyy, val|
          result[:errors] << "#{keyy.to_s} #{val.first}"
        end
        Failure(result) # result is a hash.
      else
        Success(output)
      end
    end

    def persist(input)
      account = ::Account.new(input.to_h)
      account.uid = account.email
      if account.save
        Success(account)
      else
        Failure({errors: account.errors.full_messages})
      end
    end
  end
end
