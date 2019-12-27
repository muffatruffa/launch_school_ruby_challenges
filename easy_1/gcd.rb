require 'benchmark'

class GCD
  def self.of(a, b)
    if b == 0
      return a
    else
      of(b, a % b)
    end
  end

  def self.iterative_of(m, n)
    until n == m % n
      n, m = m % n, n
      return m if n == 0
    end
    m
  end

  def self.ls_of(a, b)
    minimum = [a, b].min
    minimum.downto(1) do |divisor|
      return divisor if a % divisor == 0 && b % divisor == 0
    end
  end


  def self.between(n1,n2)
    n1_divisors = divisors(n1)
    n2_divisors = divisors(n2)
    n1_divisors.select {|n1_divisor| n2_divisors.include? (n1_divisor)}.max
  end

  def self.divisors(n)
    divisors = []
    divisor = 1
    while divisor * divisor <= n
      if n % divisor == 0
        divisors << divisor
        divisors << n / divisor unless divisor == n / divisor
      end
      divisor += 1
    end
    divisors
  end
end

if $PROGRAM_NAME == __FILE__
  p Benchmark.realtime() { GCD.between(16769023,1073676287) } # 0.0023100819962564856
  p Benchmark.realtime() { GCD.of(1_073_676_287, 16_769_023) } # 2.429005689918995e-06
  p Benchmark.realtime() { GCD.iterative_of(1_073_676_287, 16_769_023) } # 1.853004505392164e-06
  p Benchmark.realtime() { GCD.ls_of(1_073_676_287, 16_769_023) } # 0.9992588160021114

  p Benchmark.realtime() { GCD.between(1256636,1630968) } # 0.00014785800158279017
  p Benchmark.realtime() { GCD.of(1256636,1630968) } # 1.5370023902505636e-06
  p Benchmark.realtime() { GCD.iterative_of(1256636,1630968) } # 1.443004293832928e-06
  p Benchmark.realtime() { GCD.ls_of(1256636,1630968) } # 0.07525189500302076

  p GCD.between(1256636,1630968) == 4 # true
  p GCD.of(1256636,1630968) == 4 # true
  p GCD.iterative_of(1256636,1630968) == 4 # true
  p GCD.ls_of(1256636,1630968) == 4 # true
end