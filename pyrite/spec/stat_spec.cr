require "./spec_helper"
require "../src/stat" # Adjust the path as necessary

describe Pyrite::Stat::Exponential do
  describe "Exponential distribution" do
    lambda = 1.5
    exp_dist = Pyrite::Stat::Exponential.new(lambda)

    it "calculates the mean correctly" do
      mean = exp_dist.mean
      expected_mean = 1.0 / lambda
      mean.should be_close(expected_mean, 1e-6)
    end

    it "calculates the variance correctly" do
      variance = exp_dist.variance
      expected_variance = 1.0 / (lambda**2)
      variance.should be_close(expected_variance, 1e-6)
    end

    # Additional tests can be added here for other methods like pdf, sample, etc.
  end
end
