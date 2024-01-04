# math.cr
module Pyrite
  module Math
    # Constants
    PI   = ::Math::PI
    HUGE = Float64::MAX

    # Coefficients for the rational approximations
    A = [0.0, -3.969683028665376e+01, 2.209460984245205e+02, -2.759285104469687e+02,
         1.383577518672690e+02, -3.066479806614716e+01, 2.506628277459239e+00]
    B = [0.0, -5.447609879822406e+01, 1.615858368580409e+02, -1.556989798598866e+02,
         6.680131188771972e+01, -1.328068155288572e+01]
    C = [0.0, -7.784894002430293e-03, -3.223964580411365e-01, -2.400758277161838e+00,
         -2.549732539343734e+00, 4.374664141464968e+00, 2.938163982698783e+00]
    D = [0.0, 7.784695709041462e-03, 3.224671290700398e-01, 2.445134137142996e+00,
         3.754408661907416e+00]

    GAMMA_R10 = 10.900511
    GAMMA_DK  = [2.48574089138753565546e-5, 1.05142378581721974210, -3.45687097222016235469,
                 4.51227709466894823700, -2.98285225323576655721, 1.05639711577126713077,
                 -1.95428773191645869583e-1, 1.70970543404441224307e-2, -5.71926117404305781283e-4,
                 4.63399473359905636708e-6, -2.71994908488607703910e-9]
    GAMMA_C = 2 * ::Math.sqrt(::Math.exp(1) / PI)

    # Math functions and special functions
    def self.abs(x : Float64) : Float64
      ::Math.abs(x)
    end

    # ... more math function implementations ...

    def self.phi(x : Float64) : Float64
      # Ensure 0 <= phi(x) <= 1
      return 0.0 if x <= -8.0
      return 1.0 if x >= 8.0

      s = x
      b = x
      q = x**2
      i = 3

      while true
        b *= q / i.to_f
        t = s
        s += b

        break if s == t

        i += 2
      end

      0.5 + s * ::Math.exp(-0.5 * q - 0.91893853320467274178)
    end

    # ... more special function implementations ...

    def self.iphifast(p : Float64) : Float64
      if (p - 0.5).abs < 0.47575
        q = p - 0.5
        r = q ** 2
        num = (((((A[1]*r + A[2])*r + A[3])*r + A[4])*r + A[5])*r + A[6])*q
        den = (((((B[1]*r + B[2])*r + B[3])*r + B[4])*r + B[5])*r + 1.0)
        num / den
      else
        iu = (p > 0.97575 ? 1 : 0)
        z = (1 - iu) * p + iu * (1 - p)
        sign = 1 - 2 * iu
        q = ::Math.sqrt(-2 * ::Math.log(z))
        num = (((((C[1]*q + C[2])*q + C[3])*q + C[4])*q + C[5])*q + C[6])
        den = ((((D[1]*q + D[2])*q + D[3])*q + D[4])*q + 1.0)
        sign * num / den
      end
    end

    def self.iphi(p : Float64) : Float64
      return Float64::INFINITY if p >= 1
      return -Float64::INFINITY if p <= 0

      x = iphifast(p)
      e = phi(x) - p
      u = e * ::Math.sqrt(2 * PI) * ::Math.exp(x ** 2 / 2)
      x - u / (1 + x * u / 2)
    end

    def self.gamma(z : Float64) : Float64
      return PI / (::Math.sin(PI * z) * gamma(1 - z)) if z < 0

      sum = GAMMA_DK[0]
      (1..10).each do |i|
        sum += GAMMA_DK[i] / (z + i - 1)
      end

      GAMMA_C * ((z + GAMMA_R10 - 0.5) / ::Math.exp(1)) ** (z - 0.5) * sum
    end

    def self.loggamma(z : Float64) : Float64
      return ::Math.log(PI) - ::Math.log((::Math.sin(PI * z)).abs) - loggamma(1 - z) if z < 0

      sum = GAMMA_DK[0]
      (1..10).each do |i|
        sum += GAMMA_DK[i] / (z + i - 1)
      end

      ::Math.log(GAMMA_C) + (z - 0.5) * ::Math.log(z + GAMMA_R10 - 0.5) - (z - 0.5) + ::Math.log(sum)
    end
  end
end
