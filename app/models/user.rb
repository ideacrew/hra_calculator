class User

  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Enum

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  after_initialize :set_default_role, :if => :new_record?
  before_create :set_auth_token

  field :first_name,                                        type: String
  field :last_name,                                         type: String
  field :domain,                                                type: String
  field :payment_details,                               type: Hash
  field :subscriber,                                        type: Boolean
  field :stripe_details,                                type: Hash
  field :theme,                                                 type: String

  # Validation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
    before_save { self.email = email.downcase }
    before_create :create_remember_token


  # Get rid of devise-token_auth issues from activerecord
  def table_exists?
    true
  end

  def columns_hash
    # Just fake it for devise-token-auth; since this model is schema-less, this method is not really useful otherwise
    {} # An empty hash, so tokens_has_json_column_type will return false, which is probably what you want for Monogoid/BSON
  end

end