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

describe Pyrite::Stat::Normal do
  describe "Normal distribution" do
    # Test for PDF at mean
    it "calculates the PDF correctly at mean" do
      mu = 0.0
      sigma = 1.0
      normal_dist = Pyrite::Stat::Normal.new(mu, sigma)
      pdf_value = normal_dist.pdf(mu)
      expected_pdf = 1 / Math.sqrt(2 * Math::PI)
      pdf_value.should be_close(expected_pdf, 1e-6)
    end

    # Test for correct mean
    it "has the correct mean" do
      mu = 1.5
      sigma = 2.0
      normal_dist = Pyrite::Stat::Normal.new(mu, sigma)
      normal_dist.mean.should eq(mu)
    end

    # Test for correct variance
    it "has the correct variance" do
      mu = 1.5
      sigma = 2.0
      normal_dist = Pyrite::Stat::Normal.new(mu, sigma)
      normal_dist.variance.should eq(sigma**2)
    end

    # Test for plausible sample generation
    it "generates a plausible sample" do
      mu = 0.0
      sigma = 1.0
      normal_dist = Pyrite::Stat::Normal.new(mu, sigma)
      rng = Random.new
      sample = normal_dist.sample(rng)

      # Use abs directly on the number object
      (sample - mu).abs.should be <= 3 * sigma # Within 3 standard deviations
    end
  end
end
