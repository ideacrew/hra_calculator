module Operations
  class NewImportServiceArea
    include Dry::Transaction::Operation

    def call(sa_params)
      # TODO: read file to check the file data
      sa_file = sa_params[:sa_file]
      tenant = sa_params[:tenant]
      year = sa_params[:year]
      state_abbreviation = tenant.key.to_s.upcase
    end
  end
end
