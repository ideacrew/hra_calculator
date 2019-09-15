class HraResultsController < ApplicationController

  def hra_payload
    render json: {:success => true}
  end

end