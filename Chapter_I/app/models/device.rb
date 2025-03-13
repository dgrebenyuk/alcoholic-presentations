class Device < ApplicationRecord
  has_many :cameras, dependent: :destroy
  has_rich_text :description
end
