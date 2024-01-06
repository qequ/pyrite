module Pyrite
  module Stat
    # Base class for all distributions
    abstract class Distribution
      # Common methods that all distributions will have
      abstract def pdf(x : Float64) : Float64
      abstract def sample(rng : Random = Random::DEFAULT) : Float64
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

      def sample(rng : Random = Random::DEFAULT) : Float64
        -Math.log(rng.rand) / @lambda
      end

      def mean : Float64
        1.0 / @lambda
      end

      def variance : Float64
        1.0 / (@lambda**2)
      end
    end

    class Normal < Stat::Distribution
      property mu : Float64
      property sigma : Float64

      def initialize(@mu : Float64, @sigma : Float64)
        raise ArgumentError.new("sigma must be positive") if @sigma <= 0
      end

      def pdf(x : Float64) : Float64
        1 / (sigma * ::Math.sqrt(2 * ::Math::PI)) * ::Math.exp(-0.5 * ((x - mu) / sigma)**2)
      end

      def mean : Float64
        mu
      end

      def variance : Float64
        sigma**2
      end

      def sample(rng : Random = Random::DEFAULT) : Float64
        z = Pyrite::Math.iphi(rng.rand) # Using the iphi method from the Math module
        mu + sigma * z
      end
    end

    class Uniform < Distribution
      property a : Float64
      property b : Float64

      def initialize(@a : Float64, @b : Float64)
        raise ArgumentError.new("a < b is required") unless a < b
      end

      def pdf(x : Float64) : Float64
        1.0 / (b - a)
      end

      def mean : Float64
        0.5 * (a + b)
      end

      def variance : Float64
        (b - a)**2 / 12.0
      end

      def sample(rng : Random = Random::DEFAULT) : Float64
        a + (b - a) * rng.rand
      end
    end

    class MVUniform
      property a : Array(Float64)
      property b : Array(Float64)

      def initialize(@a : Array(Float64), @b : Array(Float64))
        raise ArgumentError.new("a and b must have the same size") if a.size != b.size
        a.zip(b).each_with_index do |(ai, bi), i|
          raise ArgumentError.new("a < b is required for all elements") unless ai < bi
        end
      end

      def sample(rng : Random = Random::DEFAULT) : Array(Float64)
        a.zip(b).map { |ai, bi| ai + (bi - ai) * rng.rand }
      end
    end

    class Student < Distribution
      property nu : Float64

      def initialize(@nu : Float64)
        raise ArgumentError.new("nu must be positive") if nu <= 0
      end

      def pdf(x : Float64) : Float64
        (1 + x**2 / nu)**(-0.5 * (nu + 1)) / (::Math.sqrt(nu) * Pyrite::Math.beta(0.5, 0.5 * nu))
      end

      def mean : Float64
        return Float64::NAN if nu <= 1
        0.0
      end

      def variance : Float64
        return Float64::NAN if nu <= 1
        return Float64::INFINITY if nu <= 2
        nu / (nu - 2)
      end

      def sample(rng : Random = Random::DEFAULT) : Float64
        u1 = rng.rand
        u2 = rng.rand
        ::Math.sqrt(nu * (u1**(-2 / nu) - 1)) * ::Math.cos(2 * ::Math::PI * u2)
      end
    end
  end
end
