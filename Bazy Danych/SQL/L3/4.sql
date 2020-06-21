--1
CREATE DOMAIN rodzaje_zajec AS char(1)
    CHECK (VALUE IN ('w','s','r','p','P','e','c','C','l','g')) NOT NULL;
--2 TYPE - okreslam typ dla kolumny
ALTER TABLE grupa ALTER COLUMN rodzaj_zajec TYPE rodzaje_zajec;
--3 stworz perspektywe
CREATE VIEW obsada_zajec_view (
    prac_kod, prac_nazwisko, przed_kod, przed_nazwa, rodzaj_zajec, liczba_grup, liczba_studentow ) 
    AS SELECT pr.kod_uz, nazwisko, p.kod_przed, p.nazwa, rodzaj_zajec, 
    COUNT (DISTINCT kod_grupy), COUNT (w.kod_uz)
FROM pracownik pr JOIN
    grupa USING(kod_uz) JOIN
     wybor w USING(kod_grupy) JOIN
     przedmiot_semestr USING(kod_przed_sem) JOIN
     przedmiot p USING(kod_przed)
GROUP BY 
    pr.kod_uz, nazwisko, p.kod_przed, nazwa, rodzaj_zajec;
--4 wypelnij danymi tabele obsada_zajec_tab
CREATE TABLE obsada_zajec_tab(
   prac_kod int,
   prac_nazwisko text,
   przed_kod int,
   przed_nazwa text,
   rodzaj_zajec rodzaje_zajec,
   liczba_grup bigint,
   liczba_studentow bigint);
INSERT INTO obsada_zajec_tab
  SELECT  pr.kod_uz, nazwisko, p.kod_przed, p.nazwa, rodzaj_zajec,
      count(DISTINCT kod_grupy), count(w.kod_uz)
  FROM pracownik pr JOIN
      grupa USING(kod_uz) JOIN
      wybor w USING(kod_grupy) JOIN
      przedmiot_semestr USING(kod_przed_sem) JOIN
      przedmiot p USING(kod_przed)
  GROUP BY
      pr.kod_uz, nazwisko, p.kod_przed, nazwa, rodzaj_zajec;
--5 Korzystając z perspektywy znajdź dla każdego przedmiotu obowiązkowego i podstawowego osobę, która uczyła 
--najwięcej osób tego przedmiotu.  Następnie zrób to samo korzystając z tabeli i sprawdź czy występuje 
--widoczna różnica w czasie wykonania.WYNIK: PERSPEKTYWY SA BARDZO WOLNE!!!
EXPLAIN ANALYZE SELECT prac_nazwisko, przed_nazwa
FROM obsada_zajec_view o JOIN przedmiot ON (kod_przed=przed_kod)
WHERE rodzaj IN ('o','p')
GROUP BY prac_kod,o.przed_kod, o.prac_nazwisko, przed_nazwa
HAVING sum(liczba_studentow)>=
 ALL(SELECT sum(liczba_studentow)
     FROM obsada_zajec_view o1 JOIN przedmiot ON (przed_kod=kod_przed)
     WHERE o1.przed_kod=o.przed_kod
     GROUP BY prac_kod);

EXPLAIN ANALYZE SELECT prac_nazwisko, przed_nazwa
FROM obsada_zajec_tab o JOIN przedmiot ON (kod_przed=przed_kod)
WHERE rodzaj IN ('o','p')
GROUP BY prac_kod,o.przed_kod, o.prac_nazwisko, przed_nazwa
HAVING sum(liczba_studentow)>=
 ALL(SELECT sum(liczba_studentow)
     FROM obsada_zajec_tab o1 JOIN przedmiot ON (przed_kod=kod_przed)
     WHERE o1.przed_kod=o.przed_kod
     GROUP BY prac_kod);