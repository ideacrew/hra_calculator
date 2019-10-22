require "rails_helper"

describe HraClientSession do
  context 'issuing a new session', dbclean: :after_each do
    let(:token) { HraClientSession.issue }

    it "has a matching session" do
      payload, _header = JWT.decode(token, HraClientSession::JWT_SESSION_SECRET)
      expect(HraClientSession.matching_session?(payload["hra_session_id"])).to be_truthy
    end

    it "issues a valid token" do
      expect(HraClientSession.valid_session?(token)).to be_truthy
    end
  end

  context 'given a bogus token payload' do
    let(:token) { "SOMEGARBIAGEIDKWHATEVER" }

    it "is invalid" do
      expect(HraClientSession.valid_session?(token)).to be_falsey
    end
  end

  context 'given an invalidly signed token payload' do
    let(:token) do
      payload = {
        exp: 20.minutes.from_now.to_i,
        session_id: "some random session_id"
      }
      JWT.encode(
        payload,
        bogus_signature_secret
      )
    end

    let(:bogus_signature_secret) do
      "SOMEGARBIAGEIDKWHATEVER, but this time it's the secret value"
    end

    it "can not decode" do
      expect { HraClientSession.decode_token(token) }.to raise_error(JWT::VerificationError)
    end

    it "is invalid" do
      expect(HraClientSession.valid_session?(token)).to be_falsey
    end
  end
end