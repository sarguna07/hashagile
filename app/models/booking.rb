class Booking < ApplicationRecord
  before_create do
    self.identity_id = Booking.count + 1
  end
end
