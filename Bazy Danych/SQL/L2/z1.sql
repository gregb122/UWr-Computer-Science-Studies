-- Podaj kody, imiona i nazwiska wszystkich osób, które chodziły na dowolne zajęcia z Algorytmów i 
-- struktur danych, a w jakimś semestrze późniejszym (o większym numerze) chodziły na zajęcia z Matematyki dyskretnej. 
--Za AiSD oraz MD uznaj wszystkie przedmioty, których nazwa zaczyna się od podanych nazw. Zapisz to zapytanie używając 
--operatora IN z podzapytaniem.

--uwaga: w select po przecinku podajemy alias kolumny TYLKO RAZ

--1. wyznaczam osoby, ktore chodzily na aisd
--2. wyznaczam zbior osob, ktore chodzily na MD
--3. daje warunek, ze kod uz z pierwzsego zbioru musi byc w drugim

SELECT DISTINCT uzytkownik.kod_uz, imie, nazwisko FROM uzytkownik
JOIN wybor w1 USING (kod_uz)
JOIN grupa g1 USING (kod_grupy)
JOIN przedmiot_semestr ps1 USING (kod_przed_sem)
JOIN przedmiot p1 USING (kod_przed)
WHERE p1.nazwa LIKE '%Algorytmy i struktury danych%' AND uzytkownik.kod_uz IN (
    SELECT uzytkownik.kod_uz FROM uzytkownik 
    JOIN wybor w2 USING (kod_uz)
    JOIN grupa g2 USING (kod_grupy)
    JOIN przedmiot_semestr ps2 USING (kod_przed_sem)
    JOIN przedmiot p2 USING (kod_przed)
    WHERE p2.nazwa LIKE '%Matematyka dyskretna%' AND ps1.semestr_id < ps2.semestr_id
);