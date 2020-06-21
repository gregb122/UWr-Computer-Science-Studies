require 'bigdecimal'
#niedokladnosc zmiennopozycyjnych - przyklad
x = 1.0
10000.times {x += 0.0001}
puts x

y = BigDecimal.new("1.0")
10000.times {y += BigDecimal.new("0.0001")}
puts y.to_f
#istnieje klasa Big Decimal - precyzyjna klasa do obslugi duzych liczb zmiennopoz
#metoda bez wykrzyknika zwraca nowy obiekt, a z wykrzyknikiem - modyfikuje biezacy
[1,2,3].each do |i|
  puts i
end
[1,2,3].reverse_each {|i| puts i}

c = [1,2,3,4,5]
puts c.map {|element| element += 1}

inc = 0
loop do
  puts inc
  inc = Random.new.rand(15)
  if inc > 10
    redo #tu przerywa iteracje i powtarza cala petle
  end
  #tu powtarza jedna iteracje, przerywa ja
  if inc == 10
    break
  end
  inc += 1
end
print "\n"

#while
# until - zaprzeczenie while - one tez potrafia byc modyfikatorami wyrazen
x = 1
x += 1 until x > 10
x -= 1 while x > 0
puts x
#ITERATORY
# times - najpopularniejszy
4.times do |iterator|
  puts "4 razy #{iterator}"
end
# each do - po kolekcji
["a","b","c"].each do |element|
  puts element
end
#z indeksem
["a","b","c"].each_with_index do |element,index|
  puts "#{element} ma indeks #{index}"
end
#upto - w gore od wartosci obiektu do podanej liczby
3.upto(9) {|i| puts i}
#downto  analogicznie
#step - w jakim kroku
2.step(20,4) {|i| puts i}

#WYJATKI - do obslugi bledow
#begin i rescue
a = 1
b = 0
begin
  puts a/b2
rescue ZeroDivisionError
  puts "dzielenie przez zero"
rescue => e
  raise e
end
puts "dalej dziala"
#blok else - tylko wtedy, gdy nie wystapil wyjatek
#ensure - zawsze sie wykona - sluzy do zamkniecia pliku, zamkniecia polaczenia siecowiego itp.
#dziala rowniez retry
#raise - wyrzucenie wyjatku, gdy chcemy go zwrocic
