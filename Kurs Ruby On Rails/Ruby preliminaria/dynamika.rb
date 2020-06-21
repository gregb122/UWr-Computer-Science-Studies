#otwarte klasy - to charakterystyczna cecha Rubyego
#oznacza to, ze mozemy w dowolnej chwili zmodyfikowac zachowanie istniejacej klasy oraz wbudowanej klasy
#metody rozszerzajace w C# - podobne - otwarte klasy
#metoda, ktora ma na koncu znak zapytania, zwyczajowo jest rozumiana jako predykat - metoda zwracajaca albo prawde, albo falsz
class Fixnum
  def has_one_digit?
    self.to_s.chars.uniq.size == 1
  end
end
puts 333.has_one_digit?
#W RUBY JEST INACZEJ! MOZNA MODYFIKOWAC JUZ ISTNIEJACE METODY JAKO METODY rozszerzajace
#W C# TE KLASY SA ZAPIECZETOWANE I NIE MOZNA MODYFIKOWAC ICH METOD!!!
#modyfikowanie metod istniejacych klas to monkey patching - niezalecane
#method_missing - proba reakcji na wywolanie metody, ktora nie istnieje
#respond_to?(:nazwa_metody) - podajemy


#METOD MISSING
class TestClass
  def name
  end
  def method_missing(method_name,*arguments,&block)
    #metod missing uzywamy tylko w warunku z super - nie dla wszystkich
    puts "Brak metody #{method_name}. Argumenty: #{arguments}, blok: #{block}"
     #zareaguj tak jakby to zrobil ruby
     #super
  end
end
#sprawdzamy, czy metoda istnieje respond_to
puts TestClass.new.respond_to?(:name)
puts TestClass.new.trtert
#method missing warto stosowac w przypadku, gdy chcemy np moc wywolac metode za pomoca zbioru slow podobnych

class Entry
  #metoda statyczna
  def self.find(conditions = {})
    puts "Szukam: #{conditions.inspect}"
  end
  def self.method_missing(method, *arguments,&block)
    #wyrazenia regularne - ^ start linii $-koniec linii
    #teraz tutaj mowimy, ze
    match = method.to_s.match /^find_by_(.*)$/
    if match #metoda match sprawdza dopasowanie argumentu method do wzorca z wyrazenia regularnego
      #jesli tak, to match = ["find_by","____reszta____"]
      find(match[1] => arguments.first)
    else
      super
    end

  end
#inspect - reprezentacja obiektu w postaci odczytywalnej dla programisty
end

#tu chcemy, by wszystkie odwolania zaczynajace sie find_by byly przekazywane do find
Entry.find(name:"test")
Entry.find_by_name("test")

#dDEFINE METHOD
class Person
  ["sad","happy","worried","terrified"].each do |emotion|
    define_method "make_#{emotion}" do
      instance_variable_set "@is#{emotion}",true
    end
#instance_variable_get - pobierz zmienna instancyjna, ktora jest ustawiona wg define method
    define_method "make_#{emotion}_because" do |reason|
      send("make_#{emotion}")
      instance_variable_set "@#{emotion}_reason", reason
    end

    define_method "#{emotion}?" do
      [instance_variable_get("@is_#{emotion}") ? "Yeah" : "Nope", instance_variable_get("@#{emotion}_reason")].compact.join(",")
    end
  end
end
#  def make_sad
#    @is_sad = true
#  end

#  def make_sad_because(reason)
#    make_sad
#    @sad_reason = reason
#  end

#metoda compact usuwa wszystkie nile z tablicy, join tworzy z tablicy napis, laczac po podanym argumencie
#  def sad?
#    [@is_sad ? "Yeah" : "Nope", @sad_reason].compact.join(", ")
#  end

#end

p1 = Person.new
p1.make_sad_because("C++")
puts p1.sad?
p2 = Person.new
puts p2.sad?
puts p2.happy?
