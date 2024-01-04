require "./spec_helper"
require "../src/math" # Adjust the path according to your project structure

describe Pyrite::Math do
  describe ".phi" do
    it "calculates phi for standard values" do
      Pyrite::Math.phi(0.0).should be_close(0.5, 0.0001)
      Pyrite::Math.phi(1.0).should be_close(0.8413, 0.0001)
      # Add more test cases as needed
    end
  end

  describe ".iphifast" do
    it "calculates iphifast for standard values" do
      Pyrite::Math.iphifast(0.1).should be_close(-1.2816, 0.0001)
      Pyrite::Math.iphifast(0.5).should be_close(0.0, 0.0001)
      Pyrite::Math.iphifast(0.9).should be_close(1.2816, 0.0001)
      # Add more test cases as needed
    end
  end

  describe ".iphi" do
    it "calculates iphi for standard values" do
      Pyrite::Math.iphi(0.1).should be_close(-1.2816, 0.0001)
      Pyrite::Math.iphi(0.5).should be_close(0.0, 0.0001)
      Pyrite::Math.iphi(0.9).should be_close(1.2816, 0.0001)
      # Add more test cases as needed
    end
  end

  describe ".gamma" do
    it "calculates gamma for standard values" do
      Pyrite::Math.gamma(0.5).should be_close(::Math.sqrt(::Math::PI), 0.0001)
      Pyrite::Math.gamma(1.0).should be_close(1.0, 0.0001)
      Pyrite::Math.gamma(1.5).should be_close(0.5 * ::Math.sqrt(::Math::PI), 0.0001)
      # Add more test cases as needed
    end
  end

  describe ".loggamma" do
    it "calculates loggamma for standard values" do
      Pyrite::Math.loggamma(0.5).should be_close(::Math.log(::Math.sqrt(::Math::PI)), 0.0001)
      Pyrite::Math.loggamma(1.0).should be_close(::Math.log(1.0), 0.0001)
      Pyrite::Math.loggamma(1.5).should be_close(::Math.log(0.5 * ::Math.sqrt(::Math::PI)), 0.0001)
      # Add more test cases as needed
    end
  end
end
