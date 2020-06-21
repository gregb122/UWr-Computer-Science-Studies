--1 tworzenie domeny
CREATE domain semestry AS VARCHAR
CHECK (VALUE IN('zimowy', 'letni')) not NULL;
--2
--tworze sekwencje i ustawiam jej wartosc na ostatni, max id
CREATE SEQUENCE numer_semestru;
SELECT setval('numer_semestru', max(semestr_id)) from semestr;
--ustawiam sekwencje jako funkcje dla kolumny z id
ALTER TABLE semestr ALTER COLUMN semestr_id
    SET DEFAULT nextval('numer_semestru');
--wlascicielem sekwencji jest semestr.semestr_id
ALTER SEQUENCE numer_semestru OWNED BY semestr.semestr_id;
--3
alter TABLE semestr add COLUMN semestr semestry default 'zimowy';
alter table semestr add column rok char(9);
--4
--zaktualizuj nazwy w semestr
UPDATE semestr set semestr='zimowy'
WHERE nazwa LIKE '%zimowy%';
--wytnij z nazwy 'Semestr zimowy 2018/2019' kawalek stringa '2018/2019'
UPDATE semestr
set rok = substring(nazwa FROM position('/' IN nazwa)-4 FOR 9);
--6 usuwam biezace wartosci domyslne
ALTER TABLE semestr ALTER COLUMN semestr DROP DEFAULT;
ALTER TABLE semestr ALTER COLUMN rok DROP DEFAULT;
--ustawiam nowe
ALTER TABLE semestr ALTER COLUMN semestr SET DEFAULT
    CASE WHEN EXTRACT(month FROM current_date) BETWEEN 1 AND 6
    THEN 'letni' ELSE 'zimowy'
    END;
ALTER TABLE semestr ALTER COLUMN rok set default
    CASE WHEN EXTRACT(month FROM current_date) BETWEEN 1 AND 6
    THEN EXTRACT(year from current_date)-1||'/'||EXTRACT(year from current_date)
    ELSE EXTRACT(year from current_date)||'/'||EXTRACT(year from current_date) +1
    END;
