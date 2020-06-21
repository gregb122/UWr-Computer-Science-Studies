#funkcja slownie - zamiana liczby na jej reprezentacje slowna
#wejscie liczba nat od 0 do 9999
# przypadek brzegowy - 0 -> zero, 10 - dziesiec,
#liczymy dlugosc argumentu:
# gdy jest 4 - to mamy tysiac
# gdy jest 3 - setki
#WYJATKI : dla 4 skracamy w przypadku dziesiątek : czterdzieści
def slownie(n)
  argument = n
  hash_num = {
  0 => ["jeden","dwa","trzy","cztery","pięć","sześć","siedem","osiem","dziewięć"],
  1 => ["dziesięć","dwadzieścia","trzydzieści","czterdzieści","pięćdziesiąt","sześćdziesiąt","siedemdziesiąt",
    "osiemdziesiąt","dziewięćdziesiąt"],
  2 => ["sto","dwieście","trzysta","czterysta", "pięćset", "sześćset", "siedemset",
  "osiemset","dziewięćset"],
  3 => ["tysiąc","dwa tysiące", "trzy tysiące", "cztery tysiące", "pięc tysięcy", "sześć tysięcy", "siedem tysięcy",
  "osiem tysięcy", "dziewięć tysięcy"],
  4 => ["jedenaście","dwanaście","trzynaście","czternaście","piętnaście","szesnaście","siedemnaście",
    "osiemnaście","dziewiętnaście"]
  }
  if n == 0
    return "zero"
  end
  n = n.to_s.reverse
  num_literal_result = ""
  for i in 0..(Integer(n.length)-1) do
    if n[i] != "0"
      num_literal_result = hash_num[i][Integer(n[i])-1] + " " + num_literal_result
    end
  end
  if argument < 20 && argument > 10
    return num_literal_result.split(' ')[0...-2].join(' ') + hash_num[4][Integer(n[0])-1]
  end
  if n[1] == "1" && n[0] != "0"
    return num_literal_result.split(' ')[0...-2].join(' ') + " " + hash_num[4][Integer(n[0])-1]
  end
  return num_literal_result
end

puts slownie(0)
puts slownie(6)
puts slownie(15)
puts slownie(11)
puts slownie(35)
puts slownie(74)
puts slownie(50)
puts slownie(90)
puts slownie(101)
puts slownie(192)
puts slownie(999)
puts slownie(115)
puts slownie(120)
puts slownie(1000)
puts slownie(4004)
puts slownie(2002)
puts slownie(5604)
puts slownie(1016)
puts slownie(2019)
puts slownie(7980)
puts slownie(9919)
puts slownie(9999)
