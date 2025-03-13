# frozen_string_literal: true

require 'debug'

class Bucket
  PRICES = {
    'apples' => 20,
    'bananas' => 40,
    'oranges' => 35
  }.freeze

  attr_accessor :items

  def initialize
    @items = []
  end

  def add_item(item)
    return "Error! You can add only: #{PRICES.keys.join(', ')}" unless PRICES.key?(item)

    @items << item
  end

  def +(other)
    @items.concat(other.items)
    other.items.clear
    self
  end

  def total_sum
    PRICES.values_at(*@items).sum
  end
end

bucket = Bucket.new
bucket.add_item(1)
