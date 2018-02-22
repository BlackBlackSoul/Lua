--
-- Created by Tooster on 22.02.2018 01:09
--

function primeDivisors(x)
  primes = {}
  sieve = {}
  sieve[1] = 0;
  for i=2, x-1 do sieve[i]=1 end
  for i=2, x-1 do 
    if sieve[i] == 1 and x%i == 0 then 
      primes[#primes+1] = i
      for j = i+i, sqrtlmt do sieve[j] = 0 end
    end
  end
  return primes
end