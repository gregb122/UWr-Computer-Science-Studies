#O(sqrt(n))
def isprime(n)
  if n < 2
    return false
  end
  k = 2
  while k * k <= n do
    if n % k == 0
      return false
    end
    k += 1
  end
  return true
end

#O(sqrt(n))
def podzielniki(n)
  div_array = []
  k = 2
  if n <= 1
    return div_array
  end
  while k * k <= n do
    if n % k == 0
      div_array << k
      div_array << n / k
    end
    k += 1
  end
  return div_array.uniq.sort.select {|e| isprime(e)}
end

print podzielniki(1025)
print "\n"
