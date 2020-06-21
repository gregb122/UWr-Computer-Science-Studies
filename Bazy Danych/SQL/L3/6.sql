--1. tworzenie perspektywy
CREATE VIEW plan_zajec (
 kod_stud,nazwisko_stud,
 semestr_id,rok,semestr,
 kod_przed, nazwa_przed,
 termin, sala, kod_prac, nazwisko_prac
) AS SELECT u1.kod_uz,u1.nazwisko,
 s.semestr_id,rok,s.semestr,
 p.kod_przed,p.nazwa,
 termin,sala,u2.kod_uz, u2.nazwisko
FROM student u1 JOIN wybor USING(kod_uz)
    JOIN grupa USING(kod_grupy)
    JOIN pracownik u2 ON (grupa.kod_uz=u2.kod_uz)
    JOIN przedmiot_semestr USING(kod_przed_sem)
    JOIN przedmiot p USING(kod_przed)
    JOIN semestr s USING(semestr_id);
--2 wybierz z perspektywy studenta
SELECT nazwisko_stud, rok, semestr, nazwa_przed, termin, sala, nazwisko_prac
FROM plan_zajec
WHERE kod_stud = 2230 AND semestr_id=39;
--3 wybierz z perspektywy pracownika
SELECT DISTINCT nazwisko_prac, rok, semestr, nazwa_przed, termin,sala FROM plan_zajec
WHERE kod_prac = 187 AND semestr_id = 39;
--4 wybierz plan sali w konkretnym semestrze
SELECT DISTINCT nazwa_przed, termin, nazwisko_prac
FROM plan_zajec
WHERE semestr_id = 39 AND sala = '25';