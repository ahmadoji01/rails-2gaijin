class User
  include Mongoid::Document
  include SimpleEnum::Mongoid
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  ## Database authenticatable
  field :email,                   type: String, default: ""
  field :encrypted_password,      type: String, default: ""

  ## Recoverable
  field :reset_password_token,    type: String
  field :reset_password_sent_at,  type: Time

  ## Rememberable
  field :remember_created_at,     type: Time
  field :remember_token,          type: String

  field :first_name,              type: String
  field :last_name,               type: String
  field :slug,                    type: String
  field :date_of_birth,           type: Date
  field :phone,                   type: String
  field :wechat,                  type: String
  field :created_at,              type: Time
  field :updated_at,              type: Time

  mount_uploader :avatar,         AvatarUploader

  field :provider,                type: String
  field :uid,                     type: String

  as_enum :role, :admin => 94, :user => 0, :transporter => 3
  as_enum :locale, :en => 1, "zh-CN" => 2, :ja => 3

  has_many :orders, inverse_of: :buyer
  has_many :addresses
  has_many :products
  has_and_belongs_to_many :rooms

  has_and_belongs_to_many :read_messages, :class_name => "RoomMessage", :inverse_of => :readers
  field :online,                  type: Boolean
  field :notif_read,              type: Boolean
  field :message_read,            type: Boolean

  field :receive_email,           type: Boolean

  has_and_belongs_to_many :followed_products, :class_name => "Product", :inverse_of => :followers


  ## Trackable
  # field :sign_in_count,      type: Integer, default: 0
  # field :current_sign_in_at, type: Time
  # field :last_sign_in_at,    type: Time
  # field :current_sign_in_ip, type: String
  # field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email)
    if user[0]
      user[0].provider = auth.provider
      user[0].uid = auth.uid
      return user[0]
    end

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      #user.skip_confirmation! 
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def gravatar_url
    gravatar_id = Digest::MD5::hexdigest(email).downcase
    "https://gravatar.com/avatar/#{gravatar_id}.png"
  end

end
