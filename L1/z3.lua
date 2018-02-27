--
-- Created by Tooster on 22.02.2018 01:09
--

function primeDivisors(x)
  primes = {}
  sieve = {}
  for i=2, x-1 do sieve[i]=true end
  for i=2, math.sqrt(x)+1 do 
    if sieve[i] and x%i == 0 then 
      primes[#primes+1] = i
      while x%i == 0 do x = x/i end
      for j = i+i, x-1, i do sieve[j] = false end
    end
  end
  if x ~= 1 then primes[#primes+1] = x end
  return primes
end