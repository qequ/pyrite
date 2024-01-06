module ComplexNumbers
    class Complex
      property re : Float64
      property im : Float64
  
      def initialize(@re : Float64, @im : Float64)
      end
  
      # Addition
      def +(other : Complex)
        Complex.new(self.re + other.re, self.im + other.im)
      end
  
      # Subtraction
      def -(other : Complex)
        Complex.new(self.re - other.re, self.im - other.im)
      end
  
      # Multiplication
      def *(other : Complex)
        Complex.new(self.re * other.re - self.im * other.im, 
                    self.re * other.im + self.im * other.re)
      end
  
      # Division
      def /(other : Complex)
        denom = other.re**2 + other.im**2
        Complex.new((self.re * other.re + self.im * other.im) / denom, 
                    (self.im * other.re - self.re * other.im) / denom)
      end
  
      # Absolute value (magnitude)
      def abs
        Math.sqrt(self.re**2 + self.im**2)
      end
  
      # String representation for easier debugging
      def to_s
        "#{@re} + #{@im}i"
      end
    end
  end
  