# frozen_string_literal: true

class Document < ApplicationRecord
  validates :cadastral_reference, presence: true
  validates :year, presence: true, length: { maximum: 255 }
  validates :address, presence: true, length: { maximum: 255 }
end
