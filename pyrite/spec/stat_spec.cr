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

describe Pyrite::Stat::Uniform do
  describe "Uniform distribution" do
    a = 0.0
    b = 1.0
    uni_dist = Pyrite::Stat::Uniform.new(a, b)

    it "calculates the mean correctly" do
      expected_mean = 0.5 * (a + b)
      uni_dist.mean.should eq(expected_mean)
    end

    it "calculates the variance correctly" do
      expected_variance = (b - a)**2 / 12.0
      uni_dist.variance.should eq(expected_variance)
    end

    it "generates a sample within range" do
      rng = Random.new
      sample = uni_dist.sample(rng)
      sample.should be >= a
      sample.should be <= b
    end
  end
end

describe Pyrite::Stat::MVUniform do
  describe "Multi-variate Uniform distribution" do
    a = [0.0, 1.0]
    b = [1.0, 2.0]
    mvuni_dist = Pyrite::Stat::MVUniform.new(a, b)

    it "generates samples within multi-variate range" do
      rng = Random.new
      samples = mvuni_dist.sample(rng)
      samples.each_with_index do |sample, i|
        sample.should be >= a[i]
        sample.should be <= b[i]
      end
    end
  end
end
