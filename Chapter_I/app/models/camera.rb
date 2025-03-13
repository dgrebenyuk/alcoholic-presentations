class Camera < ApplicationRecord
  enum status: { offline: 0, online: 1, rtsp_error: 2 }
  belongs_to :device, counter_cache: :channels

  encrypts :password
  broadcasts_to :device
end
