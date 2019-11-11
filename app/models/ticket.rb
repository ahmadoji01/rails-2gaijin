class Ticket
  include Mongoid::Document
  field :name, type: String
  field :email, type: String
  field :content, type: String
end
