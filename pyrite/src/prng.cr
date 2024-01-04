module Pyrite
  module PRNG
    abstract class BasePRNG
      abstract def next_bits : UInt32
      abstract def copy : BasePRNG
    end

    class Kiss99 < BasePRNG
      property s1 : UInt32
      property s2 : UInt32
      property s3 : UInt32
      property s4 : UInt32

      def initialize(s1 : UInt32? = nil, s2 : UInt32? = nil, s3 : UInt32? = nil, s4 : UInt32? = nil)
        now = Time.utc.to_unix.nanoseconds
        nanoseconds = now.total_seconds.to_f64 * 1_000_000_000
        time_val = nanoseconds.to_i64

        @s1 = s1 || (time_val & 0xFFFFFFFF).to_u32
        @s2 = s2 || ((time_val >> 16) & 0xFFFFFFFF).to_u32
        @s3 = s3 || ((time_val >> 32) ^ (time_val & 0xFFFF)).to_u32
        @s4 = s4 || ((time_val >> 48) ^ (time_val >> 16) & 0xFFFF).to_u32
      end

      def next_bits : UInt32
        # Use wrapping multiplication and addition for @s1
        multiplier = 69069_u32
        @s1 = multiplier &* @s1 &+ 1234567_u32

        @s2 ^= (@s2 << 17) | (@s2 >> 15)

        @s2 ^= (@s2 >> 13) | (@s2 << 19)

        @s2 ^= (@s2 << 5) | (@s2 >> 27)

        @s3 = 36969_u32 * (@s3 & 0xFFFF_u32) &+ (@s3 >> 16)

        @s4 = 18000_u32 * (@s4 & 0xFFFF_u32) &+ (@s4 >> 16)

        result = (@s3 << 16) | (@s4 & 0xFFFF_u32)

        result &+= @s2

        result ^= @s1

        result
      end

      def copy : BasePRNG
        Kiss99.new(@s1, @s2, @s3, @s4)
      end
    end

    # ... other PRNG implementations ...
  end
end
