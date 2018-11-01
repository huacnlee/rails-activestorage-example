class User < ApplicationRecord
  has_one_attached :avatar

  def avatar_url(style: :small)
    return "" unless self.avatar.attached?

    Rails.application.routes.url_helpers.upload_path(self.avatar.blob.key, s: style)
  end
end
