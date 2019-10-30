module Api
  class ClientSessionsController < ActionController::Base
    def issue_token
      token = HraClientSession.issue
      response.set_header("Authorization", "Bearer #{token}")
      render inline: token
    end
  end
end