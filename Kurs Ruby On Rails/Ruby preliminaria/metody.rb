#metody
def test(imie)
  puts imie
end
#ladniej jest wywolywac metody bez nawiasow - czystszy kod
test "adam"
#zwracanie wartosci
#1. poprzez return - tylko tam, gdzie chcemy przerwac dzialanie metody
#2. metoda zwroci ostatnie wyrazenie w metodzie - bo taki jest ruby, ze wszystko jest wyrazeniem
def test2(imie)
  imie
end

puts test2 "piotr"

def fib(n,index=1)
  return 1 if n == 1
  return 1 if n == 2
  fib(n-1) + fib(n-2)
end

puts fib(7)
#wargumenty nazwane i wartosci domyslne
def kolor(imie: "adam", nazwisko: "ole")
  puts "Kolor #{imie} #{nazwisko}"
end
kolor imie: "adam", nazwisko: "adam"
kolor imie: "ola"
#argumenty nazwane - tam gdzie metoda posiada duza liczbe argumentow i nie zawsze wiadomo co kazdy robi
#dynamiczna liczba argumentow
def test(a,*rest) #rest przechowuje liste pozostalych argumentow, po rest mozna zatem iterowac jak po normalnej kolekcji
  puts rest
end
test(1,4,3,5,6,5,4)
#bloki - mozemy je przekazywac jako argumenty do funkcji
# slowko yield oznacza, ze funkcja musi dostac block - chyba, ze uzyjemy block_given? - czy blok zostal podany
def twice
  if block_given?
    yield
    yield
  else
    puts "nie podane bloku"
  end
end

twice
twice {puts "blok podano"}
#mozemy definiowac wlasne bloki - np metoda times to taka metoda, ktora przyjmuje blok jako argument
3.times {|i| puts i}
#nasza wlasna
def my_times(n)#deklaracja w sposob niejawny
  m = 0
  while m!=n
    yield(m)
    m+=1
  end
end
#metoda z blokami potrafi przekazywac argument do bloku
my_times(3) {|i| puts i}

#blok mozna zadeklarowac w sposob jawny - za pomoca zmiennej z ampersand - ona przechowuje blok
#przechowuje obiekty typu Proc - czyli kawalki kodu
def blok(&block) #to jest w sposob jawny
  puts block.class
end

blok
blok {puts "blok"}
#obiekty proceduralne i lambdy. lambda to szczegolny przypadek proc
x = proc {|x| puts "powitanie #{x}"}
puts x.class
y = lambda {|x| puts "powitanie #{x}"}
#wywolujemy je poprzez metode call
x.call("dla adama!!")
#proc mozna wywolac z dowolna liczba argumentow
#lambda pilnuje liczby argumentow!!!
#obiekty proceduralne przechowuja ie tylko kawalek kodu w bloku, ale rowniez kontekst w postaci zmiennych lokalnych dookola
z = 34
def procedura
  puts z # nie zadziala
end
x = proc {puts z}#zadziala
y = lambda {puts z}

#procedura
x.call()
y.call()
double = proc {|x| x * 2}
[1,2,3,4].map(&double) #jawne przekazanie bloku





#
