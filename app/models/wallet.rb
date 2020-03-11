class Wallet
  include Mongoid::Document

  field :balance, type: Integer

  has_many :wallet_deposits
  has_many :wallet_withdrawals

  belongs_to :user
end
