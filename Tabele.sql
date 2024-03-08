CREATE TABLE Osoba (
Imie varchar(25) CHECK (len(Imie) >= 1),
Nazwisko varchar(25) CHECK (len(Nazwisko) >= 1),
Data_urodzenia date,
Kraj_urodzenia varchar(45) CHECK (len(Kraj_urodzenia) >= 1),
Plec varchar(11) CHECK (Plec = 'Kobieta' OR Plec = 'Mê¿czyzna') DEFAULT 'Brak',
ID_Osoby char(12) NOT NULL PRIMARY KEY CHECK ((LEFT(ID_Osoby, 2) = '47' 
OR LEFT(ID_Osoby, 2) = '22' OR LEFT(ID_Osoby, 2) = '00')
AND SUBSTRING(ID_Osoby, 3, 10) LIKE '%[0-9]%')
);

CREATE TABLE Widz (
login varchar(15) CHECK (len(login) >= 5),
haslo_hash varchar(255),
ID_Widza char(12) PRIMARY KEY FOREIGN KEY REFERENCES Osoba(ID_Osoby) ON DELETE CASCADE ON UPDATE CASCADE
NOT NULL CHECK (LEFT(ID_Widza, 2) = '47'
AND SUBSTRING(ID_Widza, 3, 10) LIKE '%[0-9]%') 

);

CREATE TABLE Aktor (
ID_Aktora char(12) PRIMARY KEY FOREIGN KEY REFERENCES Osoba(ID_Osoby) ON DELETE CASCADE ON UPDATE CASCADE
NOT NULL CHECK (LEFT(ID_Aktora, 2) = '22'
AND SUBSTRING(ID_Aktora, 3, 10) LIKE '%[0-9]%'),
Szkola_aktorska varchar(50),
Zyciorys varchar(300)
);

CREATE TABLE Rezyser (
ID_Rezysera char(12) PRIMARY KEY FOREIGN KEY REFERENCES Osoba(ID_Osoby) ON DELETE CASCADE ON UPDATE CASCADE
NOT NULL CHECK (LEFT(ID_Rezysera, 2) = '22'
AND SUBSTRING(ID_Rezysera, 3, 10) LIKE '%[0-9]%'),
Szkola_filmowa varchar(50),
Zyciorys varchar(300)
);

CREATE TABLE Dystrybutor(
Nazwa_firmy varchar(20),
ID_Dystrybutora char(12) PRIMARY KEY FOREIGN KEY REFERENCES Osoba(ID_Osoby) ON DELETE CASCADE ON UPDATE CASCADE 
NOT NULL CHECK (LEFT(ID_Dystrybutora, 2) = '00'
AND SUBSTRING(ID_Dystrybutora, 3, 10) LIKE '%[0-9]%')
);

CREATE TABLE Produkcja_filmowa (
Tytul varchar(50) NOT NULL,
Budzet varchar(15) CHECK (LEFT(Budzet, 1) = '$' AND SUBSTRING(Budzet, 2, len(Budzet)-1) LIKE '%[0-9]%'),
Boxoffice varchar(15) CHECK (LEFT(Boxoffice, 1) = '$' AND SUBSTRING(Boxoffice, 2, len(Boxoffice)-1) LIKE '%[0-9]%'),
Gatunek varchar(20),
Data_premiery date,
Kraj_produkcji varchar(45),
Dlugosc SMALLINT CHECK (Dlugosc >= 1 AND Dlugosc <= 600) DEFAULT 150,
ID_produkcji char(12) PRIMARY KEY NOT NULL 
CHECK (LEFT(ID_produkcji, 2) = '10'
AND SUBSTRING(ID_produkcji, 3, 10) LIKE '%[0-9]%'),
ID_Dystrybutora char(12) FOREIGN KEY REFERENCES Dystrybutor(ID_Dystrybutora) ON DELETE NO ACTION ON UPDATE NO ACTION
CHECK (LEFT(ID_Dystrybutora, 2) = '00'
AND SUBSTRING(ID_Dystrybutora, 3, 10) LIKE '%[0-9]%'),
ID_Rezysera char(12) FOREIGN KEY REFERENCES Rezyser(ID_Rezysera) ON DELETE CASCADE ON UPDATE CASCADE
CHECK (LEFT(ID_Rezysera, 2) = '22'
AND SUBSTRING(ID_Rezysera, 3, 10) LIKE '%[0-9]%'),
Krotki_opis_fabuly varchar(300)
);

CREATE TABLE Wystepy (
Rola varchar(20),
ID_Wystepu char(12) PRIMARY KEY DEFAULT 'FILM' CHECK (LEFT(ID_Wystepu, 2) = '33'
AND SUBSTRING(ID_Wystepu, 3, 10) LIKE '%[0-9]%'),
ID_Aktora char(12) FOREIGN KEY REFERENCES Aktor(ID_Aktora) ON DELETE CASCADE ON UPDATE CASCADE  DEFAULT 'FILM' 
CHECK (LEFT(ID_Aktora, 2) = '22'
AND SUBSTRING(ID_Aktora, 3, 10) LIKE '%[0-9]%'),
ID_produkcji char(12) FOREIGN KEY REFERENCES Produkcja_filmowa(ID_produkcji) NOT NULL
CHECK (LEFT(ID_produkcji, 2) = '10'
AND SUBSTRING(ID_produkcji, 3, 10) LIKE '%[0-9]%'),
);

CREATE TABLE Oceny (
Ocena SMALLINT CHECK (Ocena >= 1 AND Ocena <= 10),
ID_Wystepu char(12) FOREIGN KEY REFERENCES Wystepy(ID_Wystepu)
CHECK (LEFT(ID_Wystepu, 2) = '33'
AND SUBSTRING(ID_Wystepu, 3, 10) LIKE '%[0-9]%'),
ID_produkcji char(12) FOREIGN KEY REFERENCES Produkcja_filmowa(ID_produkcji)
CHECK (LEFT(ID_produkcji, 2) = '10'
AND SUBSTRING(ID_produkcji, 3, 10) LIKE '%[0-9]%'),
ID_Widza char(12) FOREIGN KEY REFERENCES Widz(ID_Widza) ON DELETE CASCADE ON UPDATE CASCADE
CHECK (LEFT(ID_Widza, 2) = '47'
AND SUBSTRING(ID_Widza, 3, 10) LIKE '%[0-9]%'),
Data date,
ID_Oceny varchar(26) PRIMARY KEY NOT NULL CHECK (LEFT(ID_Oceny, 4) = '9947' AND 
SUBSTRING(ID_Oceny, 5, len(ID_Oceny)-4) LIKE '%[0-9]%'),
CONSTRAINT filmLubWystep CHECK 
(
((ID_Wystepu IS NULL AND ID_produkcji IS NOT NULL) OR (ID_Wystepu IS NOT NULL AND ID_produkcji IS NULL))
AND SUBSTRING(ID_Oceny, 3, 12) = ID_Widza AND (SUBSTRING(ID_Oceny, 15, 12) = ID_produkcji OR SUBSTRING(ID_Oceny, 15, 12) = ID_Wystepu)
)
);

CREATE TABLE Typ_nagrodyAktorskiej (
Kategoria varchar(30) PRIMARY KEY CHECK (len(Kategoria) >= 5)
);

CREATE TABLE Typ_nagrodyFilmowej (
Kategoria varchar(30) PRIMARY KEY CHECK (len(Kategoria) >= 5)
);

CREATE TABLE Nagroda_aktorska (
ID_Wystepu char(12) FOREIGN KEY REFERENCES Wystepy(ID_Wystepu) ON DELETE CASCADE ON UPDATE CASCADE
CHECK (LEFT(ID_Wystepu, 2) = '33'
AND SUBSTRING(ID_Wystepu, 3, 10) LIKE '%[0-9]%'),
Kategoria varchar(30) FOREIGN KEY REFERENCES Typ_nagrodyAktorskiej(Kategoria) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL UNIQUE,
Data date,
ID_nagrodyAktorskiej char(25) NOT NULL 
CHECK (LEFT(ID_nagrodyAktorskiej, 3) = '122'
AND SUBSTRING(ID_nagrodyAktorskiej, 4, 22) LIKE '%[0-9]%'),
PRIMARY KEY(ID_Wystepu, ID_nagrodyAktorskiej)
);

CREATE TABLE Nagroda_filmowa (
ID_produkcji char(12) FOREIGN KEY REFERENCES Produkcja_filmowa(ID_produkcji) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
CHECK (LEFT(ID_produkcji, 2) = '10'
AND SUBSTRING(ID_produkcji, 3, 10) LIKE '%[0-9]%'),
Kategoria varchar(30) FOREIGN KEY REFERENCES Typ_nagrodyFilmowej(Kategoria) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL UNIQUE,
ID_nagrodyFilmowej char(25) NOT NULL 
CHECK (LEFT(ID_nagrodyFilmowej, 3) = '110'
AND SUBSTRING(ID_nagrodyFilmowej, 4, 22) LIKE '%[0-9]%'),
Data date,
PRIMARY KEY(ID_produkcji, ID_nagrodyFilmowej)
);


