class RequestOption < ApplicationRecord
  has_one :rate, dependent: :destroy
end
