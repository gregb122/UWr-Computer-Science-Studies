-- Dla każdego przedmiotu typu kurs z bazy danych podaj jego nazwę oraz liczbę osób, 
-- które na niego uczęszczały.  Uwzględnij w odpowiedzi kursy, na które nikt nie uczęszczał 
-- – w tym celu użyj złączenia zewnętrznego (LEFT JOIN lub RIGHT JOIN).
-- LEFT JOIN - to zlaczenie dwoch tabel, w ktorym lewa tabela jest w calosci przepisana, i do niej
-- sa doklejone pasujace krotki z prawej tabeli (lub nic jesli nic nie pasuje)

-- 1. Ile osob uczeszczalo na przedmiot
-- typowa konstrukcja - gdy chcemy zwrocic krotki z nazwa czegos
-- i ile itemow nalezy do tego czegos
-- to wtedy grupujemy krotki po tym czyms i mozemy wywolac counta 

SELECT przedmiot.nazwa, COUNT (DISTINCT wybor.kod_uz) FROM przedmiot
LEFT JOIN przedmiot_semestr USING(kod_przed)
LEFT JOIN grupa USING (kod_przed_sem)
LEFT JOIN wybor USING (kod_grupy)
WHERE przedmiot.rodzaj='k'
GROUP BY przedmiot.kod_przed, przedmiot.nazwa;
