class OrderTransporter
  include Mongoid::Document
  include SimpleEnum::Mongoid

  belongs_to :order
  belongs_to :transporter, :class_name => "User"

  as_enum :status, :open => 1, :accepted => 2, :rejected => 3, :waiting_buyer => 4, :taken => 5
end
