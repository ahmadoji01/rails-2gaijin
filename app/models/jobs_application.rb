class JobsApplication
  include Mongoid::Document
  include SimpleEnum::Mongoid
  
  field :name, type: String
  field :phone, type: String
  field :email, type: String
  field :jobtype, type: String
  field :age, type: Integer
  field :nationality, type: String
  field :expiry, type: Date
  field :addresslat, type: BigDecimal
  field :addresslong, type: BigDecimal
  
  belongs_to :user
  belongs_to :address, inverse_of: :jobs_applications, autosave: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  validates :terms, acceptance: true
end
