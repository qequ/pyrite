module Pyrite
  module Stat
    # Base class for all distributions
    abstract class Distribution
      # Common methods that all distributions will have
      abstract def pdf(x : Float64) : Float64
      abstract def sample(rng) : Float64
      abstract def mean : Float64
      abstract def variance : Float64
    end

    class Exponential < Stat::Distribution
      property lambda : Float64

      def initialize(@lambda : Float64)
        raise ArgumentError.new("lambda must be positive") if @lambda <= 0
      end

      def pdf(x : Float64) : Float64
        return 0.0 if x < 0
        @lambda * Math.exp(-@lambda * x)
      end

      def sample(rng) : Float64
        -Math.log(rng.rand) / @lambda
      end

      def mean : Float64
        1.0 / @lambda
      end

      def variance : Float64
        1.0 / (@lambda**2)
      end
    end
    
  end
end
