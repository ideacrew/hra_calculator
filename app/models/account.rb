# frozen_string_literal: true

class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Locker
  include ::AuthorizationConcern

  attr_accessor :login

  field :locker_locked_at, type: Time
  field :locker_locked_until, type: Time

  locker locked_at_field: :locker_locked_at,
         locked_until_field: :locker_locked_until

  ## Recoverable
  field :reset_password_redirect_url, type: String
  field :allow_password_change,       type: Boolean, default: false

  field :role, type: String, default: 'Marketplace Owner'

  ## Required
  field :provider, type: String
  field :uid,      type: String, default: ''

  ## Tokens
  field :tokens, type: Hash, default: {}

  belongs_to :enterprise, class_name: 'Enterprises::Enterprise', optional: true
  belongs_to :tenant, class_name: 'Tenants::Tenant', optional: true


  scope :by_role, ->(role) { where(role: role) }
  # include DeviseTokenAuth::Concerns::User

  index({ email: 1 }, { name: 'email_index', unique: true, background: true })
  index({ reset_password_token: 1 }, { name: 'reset_password_token_index', unique: true, sparse: true, background: true })

  class << self
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login).downcase
        where(conditions).where(email: /^#{::Regexp.escape(login)}$/i).first
      else
        where(conditions).first
      end
    end

  def current_account=(account)
    Thread.current[:current_account] = account
    end
  end
end
