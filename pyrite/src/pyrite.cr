# pyrite.cr
require "./math"
require "./prng" # Require the PRNG module
require "./root" # Require the root finding module
require "./complex"
require  "./stat"

module Pyrite
  # Here you can add more code or submodules to Pyrite
end


# Single-variate uniform distribution
uni_dist = Pyrite::Stat::Uniform.new(0.0, 1.0)
puts "Mean of Uniform distribution: #{uni_dist.mean}"
puts "Sample from Uniform distribution: #{uni_dist.sample(Random.new)}"

# Multi-variate uniform distribution
mvuni_dist = Pyrite::Stat::MVUniform.new([0.0, 1.0], [1.0, 2.0])
puts "Sample from Multi-variate Uniform distribution: #{mvuni_dist.sample(Random.new)}"
