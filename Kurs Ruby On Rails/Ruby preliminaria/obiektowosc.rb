#klasy i obiekty w Ruby
#zmienna klasy - to static C#
class Person
  #metoda klasy tak:
  @@population = 0 #dwa razy malpa - to inaczej static int population = 0
  def initialize(name) #konstruktor to initialize
    @name = name
    @@population += 1
  end
  def greet
    puts @greeting
  end
  def make_greeting
    @greeting = "Witaj" #zmienna instancji klasy - tak jak pole skladowe klasy w C# - jest przywiazana do obiektu
    greeting = "Witaj 2" # to zmienna lokalna metody, ktora jest niszczona po zakonczeniu jej wykonania
  end
  #akcesory dostepu na wzor implementacji Java
  def set_greeting(new_greeting)
    @greeting = new_greeting
  end
  def get_greeting
    @greeting
  end
  #akcesory dostepu na sposob Rubistow
  def pole=(new_pole) #seter
    @pole = new_pole
    @pole3 = "pole nr 3, nie zmienisz go"
  end
  def pole #geter
    @pole
  end
  def move
    "poruszam sie"
  end
  #to jest metoda klasy - czyli metoda statyczna
  def self.pop
    @@population
  end
  #jest tez skrotowy zapis jak w C# na getery i setery
  attr_accessor :pole2 #tak samo jak:    string pol2 {get; set;} - ten skrot definiuje setera i getera
  attr_reader :pole3 # tylko do odczytu
  attr_writer :pole4 #tylko do zapisu
end

class LoudPerson < Person#dziedziczenie wszystkich funkcjonalnosci
#przyslanianie metody jest po prostu tak:
  def greet
    puts @greeting.upcase
  end
  #przeciazanie metody to jest tak: za pomoca slowka super
  def move
    super + "bardzo glosno"
  end
end
o1 = Person.new("kasia") #konstruktor
o2 = Person.new("piotr")
puts o1==o2 # nie sa identyczne
o1.make_greeting
o1.greet #tu jest to, co zdefiniowalismy w poprzedniej metodzie
o2.greet #tu nie zdefiniowalismy zmiennej instancji, wiec nic nie ma
#jesli wywolujemy metode wewnatrz klasy, to ruby domyslnie uznaje, ze wywoluje ja w kontekscie obiektu bedacego wewnatrz tej klasy
#czyli na tym, na ktorym wywolywana jest metoda
#odwolanie sie do nieistniejacej zmiennej instancji jest dozwolone -
#zmienne instancji
o1.set_greeting("Hey there")
puts o1.get_greeting # nie mamy dostepu do zmiennej instancji z zewnatrz klasy
o1.pole = "pole nr 1"
puts o1.pole
o1.pole2 = "pole nr 2"
puts o1.pole2
o1.pole2 = "pole nr 2"
puts o1.pole3
#nie ma destruktorow - wszystko jest automatycznie
l1 = LoudPerson.new("adam")
l1.make_greeting
l1.greet
puts l1.move
o3 = Person.new("ada")
#za pomoca superclass metody mozemy zobaczyc, jaka jest nadklasa dla klasy obiektu
#wszystkie obiekty dziedzicza po BasicObject -> Object. Podobnie jak w c# jest to hierarchia na ksztalt ukorzenionego drzewa w BasicObject
puts Person.pop

#okreslenie dostepnosci metody - domyslnie wszystkie sa publiczne
#metoda prywatna to metoda do uzytku wewnetrznego dla klasy
#dekorator private oznacza, ze funkcja to szczegol implementacyjny, i nie powinna byc wywolywana spoza tej klasy
class Animal
  attr_reader :name
  @@id = 0
  def initialize(name)
    @name = name
    @@id += 1
  end
  def greeting
    puts "I am " + @name
  end
  def get_id
    my_id(@@id)
  end
  private #dekorowanie funkcji - ponizej tego symbolu wszystkie metody sa prywatne
  def my_id(new_id)
    @@id
  end

  public # a tu juz publiczne
  def self.get_id
    @@id
  end
  #protected - jak w C#, dostepne dla klas i klas dziedziczacych, bardzo rzadkie w ruby!!
  def +(other_animal)
    #uzywanie atrybutu self powoduje wywolanie akcesora do zmiennej instancyjnej
    Animal.new([self.name, other_animal.name].join(" i "))
  end

end

a1 = Animal.new("wiewiorka")
a2 = Animal.new("slon")
a1.greeting
puts a1.get_id
puts Animal.get_id

a3 = a1+ a2
puts a3.name
#operatory. Operatory to w Rubym nic innego jak metody


#
