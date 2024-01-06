require "./spec_helper"
require "../src/complex" # Adjust the path as necessary

describe ComplexNumbers::Complex do
  describe "arithmetic operations" do
    c1 = ComplexNumbers::Complex.new(1.0, 2.0) # 1 + 2i
    c2 = ComplexNumbers::Complex.new(3.0, 4.0) # 3 + 4i

    it "adds two complex numbers correctly" do
      result = c1 + c2
      result.re.should eq(4.0)
      result.im.should eq(6.0)
    end

    it "subtracts two complex numbers correctly" do
      result = c1 - c2
      result.re.should eq(-2.0)
      result.im.should eq(-2.0)
    end

    it "multiplies two complex numbers correctly" do
      result = c1 * c2
      result.re.should eq(-5.0)
      result.im.should eq(10.0)
    end

    it "divides two complex numbers correctly" do
      result = c1 / c2
      result.re.should be_close(0.44, 1e-6)
      result.im.should be_close(0.08, 1e-6)
    end
  end

  describe "magnitude calculation" do
    c1 = ComplexNumbers::Complex.new(1.0, 2.0) # 1 + 2i

    it "calculates the magnitude of a complex number correctly" do
      magnitude = c1.abs
      magnitude.should be_close(Math.sqrt(5.0), 1e-6)
    end
  end
end
