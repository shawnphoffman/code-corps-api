class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :status, :post_type, :likes_count, :markdown,
    :number

  has_many :comments
  has_many :post_user_mentions
  
  belongs_to :user
  belongs_to :project
end
