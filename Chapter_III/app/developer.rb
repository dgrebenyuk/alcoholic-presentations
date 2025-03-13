# frozen_string_literal: true

require_relative 'user'

# Representation of User with type Developer
class Developer < User
  ABILITIES = %w[code fix support].freeze

  attr_accessor :years_of_experience, :customers

  def initialize(attrs = {})
    super
    @years_of_experience = attrs[:years_of_experience]
  end

  ABILITIES.each do |ability|
    define_method "can_#{ability}?" do
      [true, false].sample
    end
  end
end

class Devops < Developer; end
