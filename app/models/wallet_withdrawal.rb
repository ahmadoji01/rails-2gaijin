class WalletWithdrawal
  include Mongoid::Document

  field :content, type: String
  field :total, type: Integer
  field :withdrawal_date, type: Time
  field :status, type: Integer

  belongs_to :wallet
end
