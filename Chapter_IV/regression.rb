# frozen_string_literal: true

require 'matrix'
require 'csv'
require 'ruby_linear_regression'

class PricePrediction
  attr_reader :x_data, :y_data, :linear_regression

  def initialize
    @x_data = []
    @y_data = []

    # Create regression model
    @linear_regression = RubyLinearRegression.new

    training
  end

  def training
    # Load data from CSV file into two arrays
    #  - one for independent variables X (x_data)
    #  - one for the dependent variable y (y_data)
    CSV.foreach('apartment_prices.csv', headers: true) do |row|
      # Each row contains:
      #  - aparment area in m2
      #  - number of rooms
      #  - distance from city center
      #  - price USD
      x_data.push [row[0].to_i, row[1].to_i, row[2].to_f]
      y_data.push row[3].to_i
    end

    # Load training data
    linear_regression.load_training_data(x_data, y_data)

    # Train the model using the normal equation
    linear_regression.train_normal_equation
  end

  def predict_for(*prediction_data)
    puts "\nApartment Characteristics:"
    puts "  - Area : #{prediction_data[0]}m2"
    puts "  - Number of Rooms : #{prediction_data[1]}"
    puts "  - Distance from the city center : #{prediction_data[2]}km"

    predicted_price = linear_regression.predict(prediction_data)

    puts "\nPredicted price : $#{format_number(predicted_price.to_i)}"
    puts ''
  end

  private

  def format_number(number)
    num_groups = number.to_s.chars.to_a.reverse.each_slice(3)
    num_groups.map(&:join).join(',').reverse
  end
end
