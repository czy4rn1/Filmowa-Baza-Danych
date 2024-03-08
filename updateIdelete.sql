UPDATE Osoba
SET Imie='Alfredo', Nazwisko='Axaltorpedo', Plec=NULL
WHERE Kraj_urodzenia != 'USA'

DELETE FROM Typ_nagrodyAktorskiej WHERE LEFT(Kategoria, 4) = 'Najl'; 
UPDATE Osoba
SET ID_Osoby='220022222222'
WHERE ID_Osoby = '220000000002'

DELETE FROM Osoba WHERE Imie='Alfredo'

SELECT * FROM Osoba WHERE LEFT(ID_Osoby, 2) = '22';
SELECT * FROM Aktor;
SELECT * FROM Rezyser;
SELECT * FROM Dystrybutor;
SELECT * FROM Widz;
SELECT * FROM Produkcja_filmowa;
SELECT * FROM Oceny;
SELECT * FROM Nagroda_aktorska;
SELECT * FROM Typ_nagrodyAktorskiej;
SELECT * FROM Wystepy;
SELECT * FROM Nagroda_filmowa;
SELECT * FROM Typ_nagrodyFilmowej;



