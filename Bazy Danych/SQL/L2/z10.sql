-- Jaka jest średnia
-- liczba osób zapisujących się na wykład w semestrze letnim 2016/2017? Zapisz to zapytanie 
-- definiując najpierw pomocniczą
--  relację (np. na liście from z aliasem), w której dla każdego interesującego cię wykładu znajdziesz liczbę zapisanych 
--  na niego osób).

SELECT AVG(liczba) FROM 
(
    SELECT przedmiot.nazwa, COUNT (DISTINCT wybor.kod_uz) AS liczba FROM wybor
    JOIN grupa USING (kod_grupy)
    JOIN przedmiot_semestr USING (kod_przed_sem)
    JOIN przedmiot USING (kod_przed)
    WHERE przedmiot_semestr.semestr_id=33 AND grupa.rodzaj_zajec='w'
    GROUP BY przedmiot.kod_przed, przedmiot.nazwa
) A;

