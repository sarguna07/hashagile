class BookingsController < ApplicationController
  def create
    object = Booking.new(allowed_params)
    status, msg, data = SeatArrangement.new(object).call

    if status
      object.output = data
      object.save!
      redirect_to booking_path(object.id), flash: { notice: msg }
    else
      redirect_to new_booking_path, flash: { error: msg }
    end
  end

  def new
    @booking = Booking.new
  end

  def show
    booking = Booking.find(params[:id])
    @output = JSON.parse(booking.output)
  end

  private

  def allowed_params
    params.require(:booking).permit(:passengers_count, :input)
  end
end
