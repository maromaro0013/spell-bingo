class User < ActiveRecord::Base
  has_many :rooms
  has_many :room_members
  has_many :spell_sheets

  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:twitter]
  devise :authentication_keys => [:login]

  def self.from_omniauth(auth)
   where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|
     user.provider = auth["provider"]
     user.uid = auth["uid"]
     user.username = auth["info"]["nickname"]
   end
  end

  def self.new_with_session(params, session)
   if session["devise.user_attributes"]
       new(session["devise.user_attributes"], without_protection: true) do |user|
         user.attributes = params
         user.valid?
       end
   else
       super
   end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login }]).first
    else
      where(conditions).first
    end
  end

  def password_required?
    super && provider.blank?
  end
end
