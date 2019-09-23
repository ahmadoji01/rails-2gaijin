class Comment
  include Mongoid::Document

  field :content, type: String
  field :created_at, type: DateTime

  belongs_to :product
  belongs_to :user

end
