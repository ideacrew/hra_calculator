require "rails_helper"

RSpec.describe Api::ClientSessionsController do
  context "issue_token" do
    let(:generated_token) { "Generated Token" }

    before do
      allow(HraClientSession).to receive(:issue).and_return(generated_token)
      get :issue_token
    end

    it "provides a new token in the body" do
      expect(response.body).to eq generated_token
    end

    it "is successful" do
      expect(response.status).to eq 200
    end

    it "includes the new token in the headers" do
      expect(response.headers["Authorization"]).to match /^Bearer #{generated_token}/
    end
  end
end