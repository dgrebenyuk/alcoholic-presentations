# frozen_string_literal: true

require_relative 'user'

# Representation of User with type Customer
class Customer < User
  attr_reader :balance

  def initialize(attrs = {})
    super
    @balance = attrs.fetch(:balance, 100_00)
  end

  def increase_balance(sum)
    @balance += sum
  end

  def assign_supporter(supporter)
    puts "Please meet #{supporter.name}"
  end
end

# Customer.new.increase_balance(100)
