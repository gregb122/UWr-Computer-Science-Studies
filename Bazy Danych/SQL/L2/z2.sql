-- Podaj kody, imiona i nazwiska wszystkich osób, które chodziły na dowolne zajęcia z Algorytmów i 
-- struktur danych, a w jakimś semestrze późniejszym (o większym numerze) chodziły na zajęcia z Matematyki dyskretnej. 
--Za AiSD oraz MD uznaj wszystkie przedmioty, których nazwa zaczyna się od podanych nazw. Zapisz to zapytanie używając 
--operatora EXISTS z podzapytaniem.

SELECT DISTINCT u1.kod_uz, imie, nazwisko FROM uzytkownik u1
JOIN wybor w1 USING (kod_uz)
JOIN grupa g1 USING (kod_grupy)
JOIN przedmiot_semestr ps1 USING (kod_przed_sem)
JOIN przedmiot p1 USING (kod_przed)
WHERE p1.nazwa LIKE '%Algorytmy i struktury danych%' AND EXISTS (
    SELECT * FROM uzytkownik u2
    JOIN wybor w2 USING (kod_uz)
    JOIN grupa g2 USING (kod_grupy)
    JOIN przedmiot_semestr ps2 USING (kod_przed_sem)
    JOIN przedmiot p2 USING (kod_przed)
    WHERE p2.nazwa LIKE '%Matematyka dyskretna%' AND ps1.semestr_id < ps2.semestr_id AND u1.kod_uz=u2.kod_uz
);
