-- Podaj kody, imiona i
-- nazwiska osób, które prowadziły jakiś wykład, ale nigdy nie prowadziły żadnego seminarium
-- (nie patrzymy, czy zajęcia były w tym samym semestrze). Pisząc zapytanie użyj operatora EXCEPT.

-- 1. wyznacz zbior osob, ktore prowadzily wyklad
-- 2. wyznacz zbior osob, ktore prowadzily seminarium
-- odejmij 1 / 2

(
SELECT u1.kod_uz, imie, nazwisko FROM uzytkownik u1
JOIN grupa g1 USING (kod_uz)
WHERE g1.rodzaj_zajec='w'
) 
EXCEPT
(
SELECT u2.kod_uz, imie, nazwisko FROM uzytkownik u2
JOIN grupa g2 USING (kod_uz)
WHERE g2.rodzaj_zajec='s'
);