class BankAccount
  include Mongoid::Document
  field :account_number, type: String
  field :bank_name, type: String

  belongs_to :user
end
