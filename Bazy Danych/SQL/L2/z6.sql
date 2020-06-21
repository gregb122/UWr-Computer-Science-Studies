--WITH
--zbior osob chodzacych na wyklady z sieci i nie chodzacych na wyklady z baz
--i odwrotnie
--BD - chodzace na bazy
--SK - na sieci
--wynik: (BD \ SK) UNION (SK \ BD)

WITH 
BD AS (
    SELECT wybor.kod_uz FROM wybor
    JOIN grupa USING (kod_grupy)
    JOIN przedmiot_semestr USING (kod_przed_sem)
    JOIN przedmiot USING (kod_przed)
    WHERE przedmiot.nazwa ='Bazy danych'
),
SK AS (
    SELECT wybor.kod_uz FROM wybor
    JOIN grupa USING (kod_grupy)
    JOIN przedmiot_semestr USING (kod_przed_sem)
    JOIN przedmiot USING (kod_przed)
    WHERE przedmiot.nazwa ='Sieci komputerowe'
)
((SELECT * FROM BD) EXCEPT (SELECT * FROM SK)) UNION
((SELECT * FROM SK) EXCEPT (SELECT * FROM BD));