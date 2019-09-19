class HraResultsController < ApplicationController

  def hra_payload
    determine_affordability = ::Transactions::DetermineAffordability.new.call(formatted_params)

    if determine_affordability.success?
      render :json => {status: "success", data: determine_affordability.success.to_h.to_json}
    else
      render :json, {status: "failure", data: determine_affordability.failure.to_h.to_json}
    end
  end

  private

  def formatted_params
    params.permit!
    # TODO: refactor this once we fix the params issue.
    params.to_h['hra_result']
  end
end
