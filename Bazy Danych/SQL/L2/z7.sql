-- Podaj kody, imiona i
-- nazwiska wszystkich prowadzących, którzy w jakiejś prowadzonej przez siebie grupie mieli więcej zapisanych osób, 
-- niż wynosił 
-- limit max_osoby dla tej grupy. Do zapisania zapytania użyj GROUP BY i HAVING.

SELECT uzytkownik.kod_uz, imie, nazwisko FROM wybor
JOIN grupa USING (kod_grupy) --dolaczamy studentow, w grupie mamy juz kod prowadzacych
JOIN uzytkownik ON (grupa.kod_uz=uzytkownik.kod_uz) --dolacz prowadzacych
GROUP BY grupa.kod_grupy, uzytkownik.kod_uz, imie, nazwisko, max_osoby 
HAVING COUNT(*) > max_osoby;

