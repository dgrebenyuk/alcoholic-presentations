# frozen_string_literal: true

# Base class for users hierarchy
class User
  attr_accessor :name, :email

  def initialize(attrs = {})
    @name = attrs[:name]
    @email = attrs[:email]
  end
end
