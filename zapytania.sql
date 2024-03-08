-- zapytanie 1 
/* Zlicz œredni¹ ocenê dla ka¿dego filmu. Posortuj filmy malej¹co wed³ug danej
oceny. Wybierz 5 najlepszych spoœród posegregowanych. */
SELECT TOP 5 AVG(CAST(Ocena AS FLOAT)) AS 'Œrednia ocena', Oceny.ID_produkcji, Produkcja_filmowa.Tytul FROM Oceny
INNER JOIN Produkcja_filmowa ON
Oceny.ID_produkcji = Produkcja_filmowa.ID_produkcji
WHERE Oceny.ID_produkcji IS NOT NULL
GROUP BY Oceny.ID_produkcji, Produkcja_filmowa.Tytul
ORDER BY AVG(CAST(Ocena as FLOAT)) DESC;

-- zapytanie 2
/* Zlicz liczbê wystêpów dla ka¿dego aktora w X roku i nastêpnie posortuj dan¹
liczbê malej¹co. */
SELECT COUNT((Wystepy.ID_Aktora)) AS 'Iloœæ filmów w roku', Osoba.Imie, Osoba.Nazwisko, YEAR((Produkcja_filmowa.Data_premiery)) AS Rok FROM Wystepy
INNER JOIN Osoba ON
Wystepy.ID_Aktora = Osoba.ID_Osoby
INNER JOIN Produkcja_filmowa ON
Wystepy.ID_produkcji = Produkcja_filmowa.ID_produkcji
WHERE YEAR((Produkcja_filmowa.Data_premiery)) = 2014
GROUP BY Wystepy.ID_Aktora, Osoba.Imie, Osoba.Nazwisko, YEAR((Produkcja_filmowa.Data_premiery))
ORDER BY COUNT((Wystepy.ID_Aktora)) DESC;

-- zapytanie 3 -- 
/* Zlicz œredni¹ ocenê filmów w roku X i wybierz tylko te które przekraczaj¹ podan¹
œredni¹ ocenê X. Nastêpnie zlicz iloœæ podanych filmów dla ka¿dego dystrybutora i posortuj
malej¹ca. */
--pozwolilem sobie zmieniæ warunek ze zliczania ocen filmów które wysz³y w X roku na 
-- filmy które wysz³y póŸniej od X roku i wczeœniej od Y roku, ¿eby by³o wiêcej wyników
SELECT COUNT(Produkcja_filmowa.ID_Dystrybutora) AS 'Iloœæ filmów', Produkcja_filmowa.ID_Dystrybutora, Osoba.Imie, Osoba.Nazwisko FROM Produkcja_filmowa 
INNER JOIN Osoba ON
Osoba.ID_Osoby = Produkcja_filmowa.ID_Dystrybutora
WHERE ( SELECT AVG(CAST(Oceny.Ocena AS FLOAT)) FROM Oceny
		WHERE Oceny.ID_produkcji = Produkcja_filmowa.ID_produkcji) >= 5.3
AND YEAR((Produkcja_filmowa.Data_premiery)) >= 1999 AND YEAR((Produkcja_filmowa.Data_premiery)) <= 2014
GROUP BY Produkcja_filmowa.ID_Dystrybutora, Osoba.Imie, Osoba.Nazwisko
ORDER BY COUNT(Produkcja_filmowa.ID_Dystrybutora) DESC

-- zapytanie 4
/* Pogrupuj aktorów którzy grali w filmach re¿ysera X wed³ug p³ci. */
SELECT COUNT(Osoba.Plec) AS 'Iloœæ wyst¹pieñ', Osoba.Plec FROM Osoba
INNER JOIN Wystepy ON
Wystepy.ID_Aktora = Osoba.ID_Osoby
INNER JOIN Produkcja_filmowa ON
Produkcja_filmowa.ID_Rezysera = '220000000021' -- rezyser - George Lucas, w bazie jest 3 razy dodana Natalie Portman, 3 razy Ewan McGregor, 3 razy Mark Hamill i 2 razy Hayden Christensen, ktorzy grali w jego filmach
WHERE Wystepy.ID_produkcji = Produkcja_filmowa.ID_produkcji
GROUP BY Osoba.Plec
ORDER BY COUNT(Osoba.Plec) DESC;

-- zapytanie 5
/* Wyœwietl listê nazw firm dystrybucyjnych oraz ich film z najwiêkszym
boxofficem, posortowan¹ malej¹co wed³ug boxoffice. */
SELECT Dystrybutor.Nazwa_firmy, '$'+CAST(MAX(CAST(SUBSTRING(Boxoffice, 2, len(Boxoffice)-1) AS INT)) AS VARCHAR) AS Boxoffice, Tytul
FROM Produkcja_filmowa
INNER JOIN Dystrybutor ON
Dystrybutor.ID_Dystrybutora = Produkcja_filmowa.ID_Dystrybutora
WHERE Produkcja_filmowa.Boxoffice = (SELECT '$'+CAST(MAX(CAST(SUBSTRING(Produkcja_filmowa.Boxoffice, 2, len(Produkcja_filmowa.Boxoffice)-1) AS INT)) AS VARCHAR) FROM Produkcja_filmowa -- podzapytanie wystepuje po to,
									 WHERE Produkcja_filmowa.ID_Dystrybutora = Dystrybutor.ID_Dystrybutora)															-- by poprawnie by³a wyswietlana nazwa najbardziej kasowej produkcji dla firmy
GROUP BY Dystrybutor.Nazwa_firmy, Tytul
ORDER BY MAX(CAST(SUBSTRING(Boxoffice, 2, len(Boxoffice)-1) AS INT)) DESC;

-- zapytanie 6
/* Wyœwietl listê imion i nazwisk aktorów, jak i liczbê nagród aktorskich jakie
uzyskali w trakcie swojej kariery. Posortuj listê malej¹co wed³ug liczby wygranych nagród. */
SELECT Osoba.Imie, Osoba.Nazwisko, COUNT(Nagroda_aktorska.ID_Wystepu) AS 'Iloœæ nagród' FROM Osoba
INNER JOIN Wystepy ON
Wystepy.ID_Aktora = Osoba.ID_Osoby
INNER JOIN Nagroda_aktorska ON
Nagroda_aktorska.ID_Wystepu = Wystepy.ID_Wystepu
WHERE LEFT(Nagroda_aktorska.Kategoria, 4) = 'Najl' OR LEFT(Nagroda_aktorska.Kategoria, 4) = 'Najw'  
GROUP BY Osoba.Imie, Osoba.Nazwisko
ORDER BY COUNT(Nagroda_aktorska.ID_Wystepu) DESC;

-- zapytanie moje z view
CREATE VIEW [Tabela aktorów z USA] AS
SELECT Osoba.Imie, Osoba.Nazwisko, Osoba.Kraj_urodzenia FROM Osoba
INNER JOIN Aktor ON
Aktor.ID_Aktora = Osoba.ID_Osoby
WHERE Osoba.Kraj_urodzenia = 'USA'

SELECT * FROM [Tabela aktorów z USA]

DROP VIEW [Tabela aktorów z USA]
