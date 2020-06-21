-- Podaj nazwę przedmiotu
-- podstawowego, na wykład do którego chodziło najwięcej różnych osób. Użyj w tym celu zapytania z GROUP BY i HAVING
-- (z warunkiem używającym ponownie GROUP BY)

-- 1. wyznacz przedmiot i jego uczestnikow grupujac po kodzie przedmiotu (nazwa jest tylko dlatego, bo jest
--zwracana w wyniku)
-- 2. teraz mozna zagregowac po kazdym przedmiocie liczbe jego sluchaczy i wybrac taka, ktora jest wieksza 
-- od pozostalych (ALL)
-- GROUP BY WYZNACZA ZBIORY DO AGREGACJI!!!
-- bez group by funkcja agregujaca zaaplikuje sie raz do calej tabeli (taka '1 duza grupa')

SELECT przedmiot.nazwa, COUNT(DISTINCT wybor.kod_uz) FROM przedmiot
JOIN przedmiot_semestr USING (kod_przed)
JOIN grupa USING (kod_przed_sem)
JOIN wybor USING (kod_grupy)
WHERE rodzaj='p' AND rodzaj_zajec='w'
GROUP BY przedmiot.kod_przed, przedmiot.nazwa
HAVING COUNT(DISTINCT wybor.kod_uz) >= ALL (
    SELECT COUNT(DISTINCT wybor.kod_uz) FROM przedmiot
    JOIN przedmiot_semestr USING (kod_przed)
    JOIN grupa USING (kod_przed_sem)
    JOIN wybor USING (kod_grupy)
    WHERE rodzaj='p' AND rodzaj_zajec='w'
    GROUP BY przedmiot.kod_przed
);
