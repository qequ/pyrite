require "./spec_helper"
require "../src/root" # Adjust the path to correctly point to your Root module file

describe Pyrite::Root do
  describe ".newton" do
    it "finds the root of x^2 - 2" do
      f = ->(x : Float64) { x**2 - 2 }
      f_prime = ->(x : Float64) { 2*x }
      root, y_value, _, _, _, _ = Pyrite::Root.newton(f, f_prime, 0.0, 2.0) do |x, y, xl, xu, yl, yu|
        (xu - xl).abs < 1e-6
      end

      root.should be_close(Math.sqrt(2), 1e-6)
    end
    it "finds the root of x + 1 in the interval [-1.0, 0.0]" do
      f = ->(x : Float64) { x + 1 }
      f_prime = ->(x : Float64) { 1 }
      root, y_value, _, _, _, _ = Pyrite::Root.newton(f, f_prime, -1.0, 0.0) do |x, y, xl, xu, yl, yu|
        (xu - xl).abs < 1e-6
      end

      root.should be_close(-1.0, 1e-6)
      y_value.should be_close(0.0, 1e-6)
    end

    it "raises an error when the root is not bracketed in the interval" do
      f = ->(x : Float64) { x**2 + 1 }
      f_prime = ->(x : Float64) { 2*x }
      expect_raises(Exception, "root not bracketed by f(xl)=2.0, f(xu)=5.0") do
        Pyrite::Root.newton(f, f_prime, 1.0, 2.0) { |x, y, xl, xu, yl, yu| false }
      end
    end

    describe ".halley" do
      it "finds the root of x^3 - x near 1" do
        f = ->(x : Float64) { [x**3 - x, 3*x**2 - 1, 6*x] }
        root_halley, _, _, _, _, _ = Pyrite::Root.halley(f, 0.5, 1.5) do |x, y, xl, xu, yl, yu|
          (y.abs < 1e-6) || (xu - xl).abs < 1e-6
        end

        root_halley.should be_close(1.0, 1e-6)
      end

      it "finds the root of sin(x)" do
        f = ->(x : Float64) { [Math.sin(x), Math.cos(x), -Math.sin(x)] }
        root_halley, _, _, _, _, _ = Pyrite::Root.halley(f, -2.0, 2.0) do |x, y, xl, xu, yl, yu|
          (y.abs < 1e-6) || (xu - xl).abs < 1e-6
        end

        root_halley.should be_close(0.0, 1e-6)
      end

      it "raises an error when the root is not bracketed" do
        f = ->(x : Float64) { [x**2 + 1, 2*x, 2] }
        expect_raises(Exception, "root not bracketed") do
          Pyrite::Root.halley(f, 1.0, 2.0) { |x, y, xl, xu, yl, yu| false }
        end
      end

      # Additional tests for other functions and edge cases
    end

    # Additional tests for other functions and edge cases
  end
end
