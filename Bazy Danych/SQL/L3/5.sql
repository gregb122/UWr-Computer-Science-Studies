--1. tworzenie tabeli - jesli mamy nowa tabele, to trzeba zalozyc serial primary key
CREATE TABLE firma (
    kod_firmy SERIAL PRIMARY KEY
    nazwa text NOT NULL,
    adres text NOT NULL,
    kontakt text NOT NULL );
--2
INSERT INTO firma(nazwa, adres, kontakt) VALUES 
('SNS','Wrocław','H.Kloss'),
('BIT','Kraków','R.Bruner'),
('MIT','Berlin','J.Kos');
--3
CREATE TABLE oferta_praktyki(
    kod_oferty SERIAL PRIMARY KEY
    kod_firmy int NOT NULL REFERENCES firma(kod_firmy)
    semestr_id int REFERENCES semestr(semestr_id)
    liczba_miejsc int
);
--4
INSERT INTO oferta_praktyki (kod_firmy,semestr_id,liczba_miejsc)
  SELECT kod_firmy,semestr_id,3
   FROM firma,semestr
   WHERE firma.nazwa='SNS' AND rok='2018/2019'
         AND semestr='letni';
INSERT INTO oferta_praktyki(kod_firmy,semestr_id,liczba_miejsc)
  SELECT kod_firmy,semestr_id,2
   FROM firma,semestr
   WHERE firma.nazwa='MIT' AND rok='2018/2019'
         AND semestr='letni';
--5
CREATE TABLE praktyki(
    student int NOT NULL REFERENCES student,
    opiekun int REFERENCES pracownik,
    oferta int NOT NULL REFERENCES oferta_praktyki(kod_oferty)
);
--8 usun z bazy wszystkie oferty, do ktorych nie zostala stworzona ani jedna perspektywa i wszystkie firmy,
--ktorych zadna oferta nie zostala wykorzystana
DELETE FROM oferta_praktyki
WHERE kod_oferty NOT IN
 (SELECT oferta FROM praktyki);
DELETE FROM firma
WHERE kod_firmy NOT IN
  (SELECT kod_firmy FROM oferta_praktyki);