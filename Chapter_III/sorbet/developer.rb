# frozen_string_literal: true
# typed: strict

# Class which represents developers. Contains Sorbet annotations
class Developer < User
  extend T::Sig

  sig { returns(String) }
  attr_accessor :name

  sig { returns(Integer) }
  attr_accessor :years_of_experience

  sig { params(name: String, years_of_experience: Integer).void }
  def initialize(name, years_of_experience)
    super
    @name = T.let(name, String)
    @years_of_experience = T.let(years_of_experience, Integer)
  end

  sig { returns(NilClass) }
  def introduce_yourself
    puts "Hi, my name is #{name} and I have #{years_of_experience} years of experience"
  end
end
