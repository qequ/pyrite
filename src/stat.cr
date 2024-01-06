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

    class Gamma < Distribution
      property alpha : Float64
      property beta : Float64

      def initialize(@alpha : Float64, @beta : Float64)
        raise ArgumentError.new("alpha and beta must be positive") if alpha <= 0 || beta <= 0
      end

      def pdf(x : Float64) : Float64
        return 0.0 if x < 0
        (beta**alpha) * (x**(alpha - 1)) * ::Math.exp(-beta * x) / ::Math.gamma(alpha)
      end

      def mean : Float64
        alpha / beta
      end

      def variance : Float64
        alpha / (beta**2)
      end

      def sample(rng : Random = Random::DEFAULT) : Float64
        alpha >= 1 ? marsaglia_tsang(alpha, rng) / beta : marsaglia_tsang(alpha + 1, rng) / beta * rng.rand**(1.0 / alpha)
      end

      private def marsaglia_tsang(a : Float64, rng : Random) : Float64
        normal_dist = Normal.new(0.0, 1.0)
        loop do
          x = normal_dist.sample(rng)
          v = (1 + x / ::Math.sqrt(9 * (a - 1.0 / 3)))**3
          u = rng.rand

          break v * (a - 1.0 / 3) if (1 - 0.0331 * x**4 - u) > 0 || (-::Math.log(u) + 0.5 * x**2 + (a - 1.0 / 3) * (1 - v + ::Math.log(v))) > 0
        end
      end
    end

    class Beta < Distribution
      property alpha : Float64
      property beta : Float64

      def initialize(@alpha : Float64, @beta : Float64)
        raise ArgumentError.new("alpha and beta must be positive") if alpha <= 0 || beta <= 0
      end

      def pdf(x : Float64) : Float64
        return 0.0 if x < 0 || x > 1
        x**(alpha - 1) * (1 - x)**(beta - 1) / Math.beta(alpha, beta)
      end

      def mean : Float64
        alpha / (alpha + beta)
      end

      def variance : Float64
        (alpha * beta) / ((alpha + beta)**2 * (alpha + beta + 1))
      end

      def sample(rng : Random = Random::DEFAULT) : Float64
        x = Gamma.new(alpha, 1).sample(rng)
        y = Gamma.new(beta, 1).sample(rng)
        x / (x + y)
      end
    end

    class LogNormal < Distribution
      property mu : Float64
      property sigma : Float64

      def initialize(@mu : Float64, @sigma : Float64)
        raise ArgumentError.new("sigma must be positive") if sigma <= 0
      end

      def pdf(x : Float64) : Float64
        return 0.0 if x < 0
        ::Math.exp(-(::Math.log(x) - mu)**2 / (2 * sigma**2)) / (x * ::Math.sqrt(2 * Math::PI) * sigma)
      end

      def mean : Float64
        ::Math.exp(mu + 0.5 * sigma**2)
      end

      def variance : Float64
        (::Math.exp(sigma**2) - 1) * ::Math.exp(2 * mu + sigma**2)
      end

      def sample(rng : Random = Random::DEFAULT) : Float64
        ::Math.exp(Pyrite::Math.iphi(rng.rand) * sigma + mu)
      end
    end
  end
end
