class BookingsController < ApplicationController
  def create
    object = Booking.new(allowed_params)
    status, msg, data = SeatArrangement.new(object).call

    if status
      object.output = data
      object.save!

      render json: {
        status: true,
        data: object.output
      }
    else
      render json: {
        status: false,
        message: msg
      }
    end
  end

  private

  def allowed_params
    params.permit(:input, :count)
  end
end
