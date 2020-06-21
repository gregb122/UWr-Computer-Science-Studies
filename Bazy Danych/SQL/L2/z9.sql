-- Dla każdego semestru
-- letniego podaj jego numer oraz nazwisko osoby, która jako pierwsza zapisała się na zajęcia w tym semestrze. 
-- Jeśli w semestrze było kilka osób, które zapisały się
-- jednocześnie:
-- 1v) podaj wszystkie;
-- 2v) podaj tę o najwcześniejszym leksykograficznie nazwisku.

--1. wyznacz dla kazdego semestru czas najwczesniejszego zapisu
--2. oznacz ja jako relacje pomocnicza ( AS "nazwy kolumn ")
--polacz z reszta zapytan


SELECT A.semestr_id, nazwisko FROM
(
    SELECT przedmiot_semestr.semestr_id AS "semestr_id", 
    MIN(data) AS "data" FROM przedmiot_semestr
    JOIN grupa USING (kod_przed_sem)
    JOIN wybor USING (kod_grupy)
    JOIN semestr USING (semestr_id)
    JOIN uzytkownik ON (wybor.kod_uz=uzytkownik.kod_uz)
    WHERE grupa.rodzaj_zajec='w' AND semestr.nazwa LIKE '%letni%'
    GROUP BY przedmiot_semestr.semestr_id
) A

JOIN wybor USING (data)
JOIN grupa USING (kod_grupy)
JOIN przedmiot_semestr USING(kod_przed_sem, semestr_id)
JOIN uzytkownik ON (wybor.kod_uz=uzytkownik.kod_uz)
Order BY 1,2;