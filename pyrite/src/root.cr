module Pyrite
    module Root
      def self.newton(f, f_prime, xl : Float64, xu : Float64, &stop : Float64, Float64, Float64, Float64, Float64, Float64 -> Bool)
        raise "xl < xu required: xl=#{xl}, xu=#{xu}" unless xl < xu
  
        yl = f.call(xl)
        yu = f.call(xu)
        return xl, yl, xl, xu, yl, yu if yl == 0
        return xu, yu, xl, xu, yl, yu if yu == 0
        raise "root not bracketed by f(xl)=#{yl}, f(xu)=#{yu}" unless yl * yu < 0
  
        x0 = xl + 0.5 * (xu - xl)
        y0 = f.call(x0)
        f10 = f_prime.call(x0)
  
        while true
          x1 = x0 - y0 / f10
          return x1, 0.0, xl, xu, yl, yu if x1 == x0 || stop.call(x1, y0, xl, xu, yl, yu)
  
          raise "x1 outside bracket, f(x0)=#{y0}, f1(x0)=#{f10}" unless xl <= x1 && x1 <= xu
  
          y1 = f.call(x1)
          f11 = f_prime.call(x1)
  
          xl, xu, yl, yu = rebracket(x1, y1, xl, xu, yl, yu)
          x0, y0, f10 = x1, y1, f11
        end
      end
  
      private def self.rebracket(x1, y1, xl, xu, yl, yu)
        yl * y1 <= 0 ? [xl, x1, yl, y1] : [x1, xu, y1, yu]
      end
    end
  end
  