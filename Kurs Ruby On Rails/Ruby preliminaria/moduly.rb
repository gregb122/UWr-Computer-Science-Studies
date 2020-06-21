#moduly maja w ruby kilka zastosowan.
#jedna z nich to modul w postaci przestrzeni nazw
#moduly pelnia role folderow

#MODULY JAKO PRZESTRZENIE NAZW
require 'date'

puts Date.new(2015, 04, 20)

module Romance
  class Date

  end
end

module Calendar
  class Date
  end
  class Event
    def test
      puts Date
      puts ::Date #tak robimy, zeby sie dostac wewnatrz klasy z modulu do wbudowanej klasy Date
      puts Romance::Date#dwukropek podwojny oznacza, ze wychodzimy na zewnatrz modulu i od gory szukamy
    end
  end
end

module Fruits
  class Date
  end
end
#tak okreslamy przestrzenie nazw
Calendar::Event.new.test

module Addressable
  attr_accessor :zip_code, :city, :street

  def full_address
    "#{street}\n#{zip_code}\nPolska"
  end
end
#moduly jako miksiny - gdy czesc funkcjonalnosci w roznych klasach jest taka sama, np adresowanie, tagowanie, itd
#miksin - klasa moze dolaczyc dowolna liczbe miksinow
class Person
  include Addressable
end
#miksiny - lekarstwo na dont repeat yourself
class School
  include Addressable
end
p = Person.new
p.zip_code = "23-545"
p.city = "warsaw"
p.street = "Chmielna"
puts p.full_address
#w bibliotece standardowej ruby tez sa miksiny
#comparable - na przyklad chcemy porownywac po dlugosci napisu
#troche to dziala jak interfejs w C# - wrzucamy po prostu gotowy miksin Comparable (jak interfejs IComparable)
#i musimy go zaimplementowac w tej klasie
class NameLength
  include Comparable

  attr_reader :name

  def initialize(name)
    @name = name
  end

  #interfejs comparable wymaga implementacji metody, ktora zwraca -1 gdy po lewej stronie jest mniejsza liczba,
  #0 gdy sa rowne, i 1 gdy jest wieksza po lewej stronie
  def <=>(other)
    self.name.length <=> other.name.length
  end
#zamiast pisac kodu dla kazdego operatora takiego, mamy miksin Comparable
#  def >(other)
#    self.name.length > other.name.length
#  end

end

n1 = NameLength.new("kota")
n2 = NameLength.new("pies")
puts n1 <= n2

#kolejny miksin - enumerable - tak samo jak w C# z yield - jest pod spodem maszyna stanowa
#zamiast implementowac osobno metod move, next i reset dla ienumerable to jest yield
#jak dolaczymy mixin enumerable, mamy wszystkie metody dla tablic, typu map, select, itd
#jesli metoda each jest poprawnie zaimplementowana, modul enumerable daje nam te wszystkie metody
class Colors
  include Enumerable

  def each
    yield "red"
    yield "green"
    yield "blue"
    yield "yellow"
  end
end

c = Colors.new
#c.each {|e| puts e}
puts c.select {|e| e.length < 6}
