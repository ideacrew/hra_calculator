module Operations
  class AgeLookup
    include Dry::Transaction::Operation

    def call(age)
      # TODO: read the lowest and highest ages from Settings/DB.
      lowest_age_for_premium_lookup = 19
      highest_age_for_premium_lookup = 66

      output = if age <= lowest_age_for_premium_lookup
                 lowest_age_for_premium_lookup
               elsif highest_age_for_premium_lookup >= age
                 highest_age_for_premium_lookup
               else
                age
               end

      Success(output)
    end
  end
end
