class SeatArrangement
  def initialize(params)
    @input_params = params['input']
    @pass_count = params['passengers_count']
  end

  def call
    error_msg = input_validation

    return [false, error_msg, []] unless error_msg.nil?

    # assign seats
    output = []
    [true, 'Array Conditions matched..!', output]
  end

  private

  attr_reader :input_params, :pass_count, :input_seats

  def input_validation
    return '2D array is missing' unless input_params.present?

    return 'Array is not in 2D format!' unless input_params.all? { |x| x.is_a?(Array) }

    return 'Array Input is not valid' if input_params.flatten.map(&:strip).reject(&:empty?).empty?

    unless input_params.all? do |x|
             x.size == 2
           end
      return 'SubArrays are not in [x,y] format'
    end

    unless pass_count.to_s.present? && pass_count.zero? && pass_count > 1
      return 'Passengers Count is missing or invalid'
    end

    if input_seats.any? do |x|
         x.any?(0)
       end
      'x and y should be a NON-ZERO values..!'
    end
  end
end
