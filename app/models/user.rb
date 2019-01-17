class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook google_oauth2]
  has_many :item_comments
  has_many :sns_credentials, dependent: :destroy
  has_one :address
  has_many :items, dependent: :destroy
  # has_many :transaction_users, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :trades, dependent: :destroy
  has_many :transaction_comments, dependent: :destroy
  has_many :rates
  has_many :likes

  def self.find_for_oauth(auth)
    sns = SnsCredential.where(uid: auth.uid, provider: auth.provider).first
    unless sns
      @user = User.create(
      nickname:    auth.info.name,
      email:    auth.info.email,
      password: Devise.friendly_token[0,20]
      )
      sns = SnsCredential.create(
      user_id: @user.id,
      uid: auth.uid,
      provider: auth.provider
      )
   end
    sns
    @user
  end

end
