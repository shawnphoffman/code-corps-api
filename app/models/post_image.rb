# == Schema Information
#
# Table name: post_images
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  post_id            :integer          not null
#  filename           :text             not null
#  base64_photo_data  :text             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

require "code_corps/scenario/notify_pusher_of_post_image"

class PostImage < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates_presence_of :user
  validates_presence_of :post
  validates_presence_of :filename
  validates_presence_of :base64_photo_data

  has_attached_file :image,
                    path: "posts/:post_id/images/:id/:style.:extension"

  validates_attachment_content_type :image,
                                    content_type: %r{^image\/(png|gif|jpeg)}

  validates :base64_photo_data, base64_photo_data: true

  validates_attachment_size :image, less_than: 10.megabytes

  def decode_image_data
    return unless base64_photo_data.present?
    data = Paperclip.io_adapters.for(base64_photo_data)
    data.original_filename = self.filename
    self.image = data
  end

  Paperclip.interpolates :post_id do |attachment, style|
    attachment.instance.post_id
  end
end
