module Api
  class HraResultsController < ApplicationController
    def hra_payload
      determine_affordability = ::Transactions::DetermineAffordability.new.call(formatted_params)

      if determine_affordability.success?
        render plain: {status: "success", data: determine_affordability.success}.to_json, content_type: 'application/json'
      else
        # render plain: {status: "failure", data: determine_affordability.failure.to_h}.to_json, content_type: 'application/json'
        render plain: {status: "failure", data: {}, errors: determine_affordability.failure[:errors]}.to_json, content_type: 'application/json'
      end
    end

    private

    def formatted_params
      params.permit!
      # TODO: refactor this once we fix the params issue.
      params[:hra_result].to_h.merge({tenat: params[:tenant].to_sym})
    end
  end
end
