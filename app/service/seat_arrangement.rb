class SeatArrangement
  def initialize(params)
    @input_params = JSON.parse(params[:input])
    @pass_count = params[:passengers_count]
  end

  def call
    error_msg = input_validation

    return [false, error_msg, []] unless error_msg.nil?

    set_defaults
    output = []

    [true, 'Array Conditions matched..!', arrange_seats]
  end

  private

  attr_reader :input_params, :pass_count, :input_seats, :maximum_cols, :passengers_initial_count, :calculate_total_seats,
              :available_seats, :sorted_seats, :aisle_seats, :window_seats, :center_seats

  def input_validation
    return '2D array is missing' unless input_params.present? && input_params.is_a?(Array)
    return 'Array is not in 2D format!' unless input_params.all? { |x| x.is_a?(Array) }
    unless input_params.all? do |x|
             x.size == 2
           end
      return 'SubArrays are not in [x,y] format'
    end
    unless pass_count.to_s.present? || pass_count.zero? || pass_count > 1
      return 'Passengers Count is missing or invalid'
    end

    if input_params.any? do |x|
         x.any?(0)
       end
      'x and y should be a NON-ZERO values..!'
    end

    return "Oops..! We have only #{calculate_total_seats} seats" if pass_count > calculate_total_seats
  end

  def set_defaults
    @maximum_cols = input_params.map(&:last).max
    @passengers_initial_count = 0
  end

  def arrange_seats
    make_seats
    assign_aisle_seats
    assign_window_seats
    assign_center_seats
  end

  def make_seats
    @available_seats = input_params.each_with_object([]).with_index do |(arr, seats), _index|
      seats << (1..arr[1]).map { |_x| Array.new(arr[0]) { 'A' } }
    end
    @sorted_seats = (1..maximum_cols).each_with_object([]).with_index do |(_x, arr), index|
      arr << available_seats.map { |x| x[index] }
    end
  end

  def assign_aisle_seats
    @aisle_seats = sorted_seats.each_with_object([]) do |ele_arr, res_arr|
      res_arr << if ele_arr.nil?
                   nil
                 else
                   ele_arr.each_with_object([]).with_index do |(array1, array2), i|
                     array2 << if array1.nil?
                                 nil
                               else

                                 if i == 0
                                   @passengers_initial_count += 1
                                   array1[-1] = calculate_arr_value
                                 elsif i == ele_arr.size - 1
                                   unless array1.size == 1
                                     @passengers_initial_count += 1
                                     array1[0] = calculate_arr_value
                                   end
                                 else
                                   @passengers_initial_count += 1
                                   array1[0] = calculate_arr_value
                                   unless array1.size == 1
                                     @passengers_initial_count += 1
                                     array1[-1] = calculate_arr_value
                                   end
                                 end

                                 array1
                               end
                   end
                 end
    end
  end

  def assign_window_seats
    @window_seats = aisle_seats.each_with_object([]) do |ele_arr, res_arr|
      res_arr << if ele_arr.nil?
                   nil
                 else
                   ele_arr.each_with_object([]).with_index do |(arr1, arr2), i|
                     arr2 << if arr1.nil?
                               nil
                             else
                               if i == 0
                                 add_passengers_initial_count
                                 arr1[0] = calculate_arr_value
                               elsif i == ele_arr.size - 1
                                 add_passengers_initial_count
                                 arr1[-1] = calculate_arr_value
                               end
                               arr1
                             end
                   end
                 end
    end
  end

  def assign_center_seats
    @center_seats = window_seats.each_with_object([]) do |ele_arr, res_arr|
      res_arr << if ele_arr.nil?
                   ""
                 else
                   ele_arr.each_with_object([]).with_index do |(array1, array2), _i|
                     array2 << if array1.nil?
                                 ""
                               else
                                 if array1.size > 2
                                   (1..array1.size - 2).each do |x|
                                     add_passengers_initial_count
                                     array1[x] = calculate_arr_value
                                   end
                                 end
                                 array1
                               end
                   end
                 end
    end
  end

  def calculate_total_seats
    @calculate_total_seats ||= input_params.inject(0) { |sum, a| sum += a[0] * a[1] }
  end

  def calculate_arr_value
    if passengers_initial_count <= pass_count
      passengers_initial_count.to_s.rjust(calculate_total_seats.to_s.size,
                                          '0')
    else
      'X' * calculate_total_seats.to_s.size
    end
  end

  def add_passengers_initial_count
    @passengers_initial_count += 1
  end
end
