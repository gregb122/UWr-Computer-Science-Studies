-- Podaj kody, imiona i
-- nazwiska osób, które prowadziły jakiś wykład, ale nigdy nie prowadziły żadnego seminarium
-- (nie patrzymy, czy zajęcia były w tym samym semestrze). Pisząc zapytanie użyj operatora NOT EXISTS.

-- 1. wyznacz zbior osob, ktore prowadzily wyklad
-- 2. powiedz, ze nie istnieje taka sama osoba, ktora
-- prowadzilaby seminarium

SELECT DISTINCT u1.kod_uz, nazwisko, imie FROM uzytkownik u1
JOIN grupa g1 USING (kod_uz) 
WHERE g1.rodzaj_zajec='w' AND NOT EXISTS (
    SELECT * FROM uzytkownik u2
    JOIN grupa g2 USING (kod_uz)
    WHERE g2.rodzaj_zajec='s' AND u1.kod_uz=u2.kod_uz
);