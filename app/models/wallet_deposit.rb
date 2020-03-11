class WalletDeposit
  include Mongoid::Document

  field :content, type: String
  field :total, type: Integer
  field :deposit_date, type: DateTime
  field :status, type: Integer

  belongs_to :wallet
end
