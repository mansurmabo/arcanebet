# frozen_string_literal: true

class RequestOption < ApplicationRecord
  has_one :rate, dependent: :destroy
end
