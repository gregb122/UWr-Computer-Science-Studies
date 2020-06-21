--Kto prowadzi w jednym semestrze grupę wykładową do przedmiotu i co najmniej dwie grupy 
-- innych zajęć do tego przedmiotu (nie muszą być tego samego typu)? 

-- wyznacz 3 grupy, 

SELECT DISTINCT uzytkownik.nazwisko FROM uzytkownik 
JOIN grupa g1 USING (kod_uz)
JOIN grupa g2 USING (kod_uz)
JOIN grupa g3 USING (kod_uz)
WHERE g1.rodzaj_zajec='w' AND g2.rodzaj_zajec <> 'w' AND g3.rodzaj_zajec <>'w'
AND g1.kod_przed_sem = g2.kod_przed_sem AND g1.kod_przed_sem = g3.kod_przed_sem
AND g3.kod_grupy<>g2.kod_grupy;