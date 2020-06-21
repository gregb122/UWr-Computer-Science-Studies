--tworzenie tabel z kluczem glownym
--CREATE TABLE pracownik (kod_uz, imie, nazwisko);
CREATE TABLE pracownik LIKE uzytkownik;
ALTER TABLE pracownik DROP COLUMN semestr;
ALTER TABLE pracownik ADD CONSTRAINT pracownik_pk
PRIMARY KEY (kod_uz);
--CREATE TABLE student (kod_uz, imie, nazwisko, semestr);
CREATE TABLE student LIKE uzytkownik;
ALTER TABLE student ADD CONSTRAINT student_pk
PRIMARY KEY (kod_uz);

--2 wstaw krotki spelniajace warunek
INSERT INTO pracownik(kod_uz, imie, nazwisko)
    SELECT kod_uz, imie, nazwisko FROM uzytkownik
    JOIN grupa USING (kod_uz)
;
--3
INSERT INTO student(kod_uz, imie, nazwisko, semestr) 
    SELECT kod_uz, imie, nazwisko, semestr FROM uzytkownik
    JOIN wybor USING (kod_uz)
;
--przerob wiezy klucza obcego
ALTER TABLE wybor DROP CONSTRAINT fk_wybor_uz;
ALTER TABLE wybor ADD CONSTRAINT fk_wybor_st
    FOREIGN KEY (kod_uz) REFERENCES student(kod_uz) DEFERRABLE;

ALTER TABLE grupa DROP CONSTRAINT fk_grupa_uz;
ALTER TABLE grupa ADD CONSTRAINT fk_grupa_pr
    FOREIGN KEY (kod_uz) REFERENCES pracownik(kod_uz) DEFFERABLE;