module Operations
  class AnnualAmount
    include Dry::Transaction::Operation

    def call(hash_obj)
      frequency = hash_obj[:frequency]
      amount = hash_obj[:amount]
      frequency.downcase == 'annually' ? amount : (amount * 12)
    end
  end
end
