module Operations
  class AgeOn
    include Dry::Transaction::Operation

    def call(hra_object)
      date = hra_object.start_month
      dob = hra_object.dob

      Success(((date.to_time - dob.to_time) / 1.year.seconds).floor)
    end
  end
end
