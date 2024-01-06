# Pyrite

![Pyrite Logo](./logo/pyrite_logo.png)

Pyrite is a Crystal library for scientific computing, heavily inspired by the SciLua library. It provides a range of functionalities including complex numbers, special mathematical functions, pseudorandom number generators (PRNGs), root-finding algorithms, and statistical distributions. Pyrite is designed for applications requiring high performance and accurate computations in scientific and engineering domains.

## Installation

Add this to your application's shard.yml:

```yaml
dependencies:
  pyrite:
    github: qequ/pyrite
```

Then run:

```bash
$ shards install
```

## Usage

### Complex Numbers

```crystal

require "pyrite/complex"

# Creating complex numbers
c1 = ComplexNumbers::Complex.new(2.0, 3.0)
c2 = ComplexNumbers::Complex.new(1.0, 3.0)

# Operations
sum = c1 + c2
difference = c1 - c2
product = c1 * c2
quotient = c1 / c2
magnitude = c1.abs

puts "Sum: #{sum}"
puts "Difference: #{difference}"
puts "Product: #{product}"
puts "Quotient: #{quotient}"
puts "Magnitude of c1: #{magnitude}"

```

### Mathematical Functions
    
```crystal
require "pyrite/math"

# Special functions and constants
puts "Pi: #{Pyrite::Math::PI}"
puts "Absolute value: #{Pyrite::Math.abs(-3.5)}"
puts "Phi function: #{Pyrite::Math.phi(1.0)}"
```

### Pseudorandom Number Generators

```crystal
require "pyrite/prng"

# Kiss99 PRNG
rng = Pyrite::PRNG::Kiss99.new
puts "Random number: #{rng.next_bits}"
```

### Root-finding Algorithms

```crystal
require "pyrite/root"

# Newton method example
f = ->(x : Float64) { x**2 - 2 }
f_prime = ->(x : Float64) { 2*x }
root, _ = Pyrite::Root.newton(f, f_prime, 0.0, 2.0) { false }
puts "Root of x^2 - 2: #{root}"
```



## Development

After checking out the repo, run shards install to install dependencies. Then, run `crystal spec` to run the tests.


## Roadmap

Pyrite is continuously evolving, and there are several features and enhancements planned for future releases. The following is a list of potential additions to the library:

- Quasi Random Number Generators (QRNGs): Implement advanced random number generators that can produce quasi-random sequences, offering better coverage of the space than standard pseudorandom number generators.

- Differentiation: Include numerical differentiation capabilities to calculate derivatives of functions, which are essential in various scientific computations.

- Interpolation: Develop methods for interpolating data points, useful in data analysis, curve fitting, and creating smoother transitions between discrete data points.

- Matrix and Algebra: Expand the library to include matrix operations and linear algebra functionalities, which are fundamental in many scientific and engineering applications.

- Optimization Algorithms: Integrate optimization algorithms for finding minima/maxima of functions, which are crucial in fields like machine learning, economics, and engineering design.

- Statistical Analysis Tools: Enhance the statistical capabilities of the library with tools for data analysis, hypothesis testing, regression, and other statistical methods.

- Numerical Integration (Quadrature): Add methods for numerical integration to approximate the integral of functions, a common task in many scientific fields.

- Time Series Analysis: Implement functionality for analyzing and manipulating time series data, important in fields such as finance, economics, and meteorology.

- Signal Processing: Include tools for analyzing, modifying, and synthesizing signals, useful in audio processing, telecommunications, and control systems.

- Graphical and Visualization Tools: Develop visualization tools for data exploration and presentation, an important aspect of data analysis and scientific research.

- Expand Statistical Distributions: Add more statistical distributions and enhance existing ones to cover a wider range of applications.

- Parallel and Distributed Computing: Explore opportunities to leverage Crystal's concurrency model for parallel and distributed computing.

These enhancements aim to make Pyrite a more comprehensive toolkit for scientific computing in Crystal, catering to a wide range of applications and user needs.

## Contributing

1. Fork it (<https://github.com/qequ/pyrite/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Alvaro Frias Garay](https://github.com/qequ) - creator and maintainer


This project is based on and inspired by [SciLua](https://github.com/stepelu/lua-sci). The goal of Pyrite is to bring similar capabilities to the Crystal language, leveraging its performance and syntax features.