--1 dodaj nowy semestr letni i zimowy
INSERT INTO semestr(semestr, rok) VALUES
    ('zimowy', '2018/2019'),
    ('letni', '2018/2019');
CREATE SEQUENCE numer_przedmiot_semestr; --znowu sekwencje
SELECT setval('numer_przedmiot_semestr', max(kod_przed_sem)) FROM przedmiot_semestr;-- ustawiam jej wartosc
ALTER TABLE przedmiot_semestr ALTER COLUMN kod_przed_sem SET DEFAULT-- nakladam sekwencje na kolumne
    NEXTVAL('numer_przedmiot_semestr');
ALTER SEQUENCE numer_przedmiot_semestr OWNED BY przedmiot_semestr.kod_przed_sem;--wiaze je ze soba
CREATE SEQUENCE numer_grupy;
SELECT setval('numer_grupy', max(kod_grupy)) FROM grupa;
ALTER TABLE grupa ALTER COLUMN kod_grupy SET DEFAULT
    nextval('numer_grupy');
ALTER SEQUENCE numer_grupy OWNED BY grupa.kod_grupy;
--2 stworz nowa edycje przedmiotow (skopiuj te przedmioty ze starej edycji, ale z nowym semestr_id)
INSERT INTO przedmiot_semestr (semestr_id, kod_przed, strona_domowa, angielski)
    SELECT s1.semestr_id, p.kod_przed, strona_domowa, angielski FROM semestr s1, przedmiot p
    JOIN przedmiot_semestr USING (kod_przed)
    JOIN semestr s USING(semestr_id)
    WHERE rodzaj IN ('p', 'o') AND
        s.rok = '2016/2017' AND
        s.semestr=s1.semestr AND
        s1.rok = '2018/2019';
--3 najpierw wyczyscic ograniczenie kolumny kod_uz, ktora ma byc NOT NULL
ALTER tABLE grupa ALTER COLUMN kod_uz DROP not null;
-- zdefiniuj grupe wykladowa dla kazdego przedmiotu
INSERT INTO grupa (kod_przed_sem, max_osoby, rodzaj_zajec)
    SELECT kod_przed_sem, 100, 'w' FROM przedmiot_semestr
    JOIN semestr USING (semestr_id)
    WHERE rok='2018/2019';
--4 sprawdzenie
SELECT kod_grupy, nazwa, rodzaj_zajec, max_osoby
FROM grupa JOIN
     przedmiot_semestr USING(kod_przed_sem) JOIN
     przedmiot USING(kod_przed) JOIN
     semestr USING(semestr_id)
WHERE rok='2018/2019';

