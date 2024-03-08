UPDATE Osoba
SET Imie='Alfredo', Nazwisko='Axaltorpedo', Plec=NULL
WHERE Kraj_urodzenia != 'USA'

DELETE FROM Typ_nagrodyAktorskiej WHERE LEFT(Kategoria, 4) = 'Najl'; 

DELETE FROM Osoba WHERE Imie='Alfredo'

SELECT * FROM Aktor;
SELECT * FROM Rezyser;
SELECT * FROM Dystrybutor;
SELECT * FROM Widz;
SELECT * FROM Produkcja_filmowa;
SELECT * FROM Osoba;
SELECT * FROM Oceny;
SELECT * FROM Nagroda_aktorska;
SELECT * FROM Typ_nagrodyAktorskiej;
SELECT * FROM Wystepy;
SELECT * FROM Nagroda_filmowa;
SELECT * FROM Typ_nagrodyFilmowej;