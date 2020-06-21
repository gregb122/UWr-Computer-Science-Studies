def pierwsza(n)
  return (2..n).select{|i| (2..Math.sqrt(i)).all?{|j| i % j != 0} }
end

def doskonale(n)
  return (2..n).select{|i| (1..Math.sqrt(i)).select{|j| i % j == 0}.inject{|sum,k| sum + k + (i/k)}==i}
end


print pierwsza(-4)
print ("\n")
print pierwsza(1)
print ("\n")
print pierwsza(2)
print ("\n")
print pierwsza(50)
print ("\n")
print pierwsza(2500)
print ("\n")

print doskonale(7)
print ("\n")
print doskonale(1000)
print ("\n")
print doskonale(10000)
print("\n")

print zaprzyjaznione(300)
