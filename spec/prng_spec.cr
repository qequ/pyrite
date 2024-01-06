require "./spec_helper"
require "../src/prng"

describe Pyrite::PRNG::Kiss99 do
  it "produces consistent sequence with given seeds" do
    prng1 = Pyrite::PRNG::Kiss99.new(12345, 67890, 13579, 24680)
    prng2 = Pyrite::PRNG::Kiss99.new(12345, 67890, 13579, 24680)

    # Check if two instances with the same seeds produce the same sequence
    5.times do
      prng1.next_bits.should eq(prng2.next_bits)
    end
  end

  it "produces different sequence with different seeds" do
    prng1 = Pyrite::PRNG::Kiss99.new(12345, 67890, 13579, 24680)
    prng2 = Pyrite::PRNG::Kiss99.new(54321, 9876, 97531, 8642)

    # Check if two instances with different seeds produce different sequences
    different = false
    5.times do
      if prng1.next_bits != prng2.next_bits
        different = true
        break
      end
    end

    different.should be_true
  end

  # The test for generating random numbers should be here, not nested inside another 'it' block
  it "generates random numbers" do
    lfib4 = Pyrite::PRNG::Lfib4.new
    num1 = lfib4.next_bits
    num2 = lfib4.next_bits
    num1.should_not eq(num2)
  end

  it "produces a reproducible sequence with the same seed" do
    lfib4a = Pyrite::PRNG::Lfib4.new
    lfib4b = Pyrite::PRNG::Lfib4.new

    numbers_a = Array.new(10) { lfib4a.next_bits }
    numbers_b = Array.new(10) { lfib4b.next_bits }
    numbers_a.should eq(numbers_b)
  end

  # Additional tests can be added as needed
end
