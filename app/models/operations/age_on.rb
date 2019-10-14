module Operations
  class AgeOn
    include Dry::Transaction::Operation

    def call(params)
      Success(((params[:start_month].to_time - params[:dob].to_time) / 1.year.seconds).floor)
    end
  end
end
