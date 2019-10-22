require 'securerandom'
require 'base64'

class HraClientSession
  include Mongoid::Document
  include Mongoid::Timestamps

  field :session_id, type: String
  field :expires_at, type: Time

  JWT_SESSION_SECRET = Base64.decode64(Rails.application.credentials.jwt_secret_key)

  def self.issue
    # We could also cheat and use a 
    session_id = SecureRandom.uuid
    expires_at = 20.minutes.from_now
    payload = {
      exp: expires_at.to_i,
      hra_session_id: session_id
    }
    HraClientSession.create!({
      session_id: session_id,
      expires_at: expires_at
    })
    JWT.encode(
        payload,
        JWT_SESSION_SECRET
    )
  end

  def self.valid_session?(token_b64_value)
    begin
      # Already takes care of kicking out old tokens that have expired
      payload, header = decode_token(token_b64_value)
      exp = payload['exp']
      session_id = payload['hra_session_id']
      return false if exp.blank? || session_id.blank?
      matching_session?(session_id)
    rescue JWT::DecodeError
      false
    end
  end

  def self.matching_session?(session_id, time_limit = Time.now)
    HraClientSession.where({
      session_id: session_id,
      expires_at: {"$gte" => time_limit}
    }).any?
  end

  def self.decode_token(token_value)
    JWT.decode(token_value, JWT_SESSION_SECRET)
  end
end
