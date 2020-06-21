puts "Jak Ci na imie?"
#funkcja gets pobiera z std in ciag znakow, a metoda chomp ucina ostatni znak enter
#name = gets.chomp
#konkatenacja jak w Pythonie
puts "Witaj"
#Skrypt runner - za pomoca jednego klawisza mozna ustawic, ze odpala nam sie skrypt- zeby nie przeskakiwac caly czas miedzy tabami do terminala
#kazdy edytor to obsuguje
x = 2
 signum = if x < 0
   -1
 elsif x == 0
   0
 elsif x > 0
   1
 end

puts signum
#instrukcja case
#wariant 1 - w when po prostu sprawdzamy warunki
x = 15
case
when x==1
  puts "x = 1"
when x > 2
  puts "x > 2"
else
  puts "inna wartosc"
end
#wariant 2 - w case okreslamy co sprawdzamy a w when podajemy tylko przypadek gdy to cos ma synergie z tym przypadkiem
case x
when 1
  puts "x = 1"
when 10..19 # zcy x nalezy do przedzialu
  puts "10 <= x <20"
when 3,5,7,9 # czy x jest rowny ktorejkolwiek z tej wartosci
  puts "x jest nieparzysty miedzy 3 a 9 wlacznie"
else
  puts "inna wartosc"
end
#wariant 3
y = 10
result = case y
when 1
  "jedynka"
when 2,3
  "dwa lub trzy"
when 4...10
  "od cztery do dziewięć"
else
  "Większy od 10 lub mniejszy od 1"
end
puts result
#petle
