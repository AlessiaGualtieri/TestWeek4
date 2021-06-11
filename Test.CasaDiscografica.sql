--CREATE DATABASE CasaDiscografica

CREATE TABLE Band
(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		Nome VARCHAR(40) NOT NULL,
		NrComponenti INT NOT NULL,
		CHECK(NrComponenti > 0)
)

CREATE TABLE Album
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	Titolo VARCHAR(20) NOT NULL,
	AnnoUscita INT,
	CasaDiscografica VARCHAR(30) NOT NULL,
	Genere VARCHAR (20) NOT NULL,
	SupportoDistribuzione VARCHAR(20) NOT NULL,
	BandID INT NOT NULL,
	CHECK(AnnoUscita > 0),
	CHECK ( Genere IN ('Classico','Jazz','Pop','Rock','Metal') ),
	CHECK (SupportoDistribuzione IN ('CD','Vinile','Streaming')),
	UNIQUE (Titolo,AnnoUscita,CasaDiscografica,Genere, SupportoDistribuzione)
)

CREATE TABLE Brano
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	Titolo VARCHAR(40) NOT NULL,
	Durata_s INT NOT NULL,
	CHECK (Durata_s > 0)
)


CREATE TABLE AlbumBrano
(
	AlbumID INT NOT NULL,
	BranoID INT NOT NULL,
	FOREIGN KEY (AlbumID) REFERENCES Album(ID),
	FOREIGN KEY (BranoID) REFERENCES Brano(ID)
)


-------------------------------------------------------------
-------------------- INSERIMENTO VALORI ---------------------
-------------------------------------------------------------

INSERT INTO Band VALUES
('883',4),
('Maneskin',5),
('The Giornalisti',3),
('Pinguini Tattici Nucleari',5)



SELECT * FROM BAND

INSERT INTO Album VALUES
('sUPERaLBUM', 2010, 'Caza','Pop','CD',1),
('sUPERaLBUM', 2010, 'Caza','Pop','Streaming',1),
('Ridere',2018,'Sutter','Pop','CD',4),
('Ridere',2018,'Sutter','Pop','Streaming',4),
('Ridere',2018,'Sutter','Pop','Vinile',4),
('Daje Sanremo',2021,'Caza','Rock','Streaming',2),
('Daje Sanremo',2021,'Caza','Rock','CD',2),
('Daje Sanremo',2021,'Caza','Rock','Vinile',2),
('Daje Eurovision',2021,'Caza','Rock','Streaming',2),
('Slurp',2018,'Sutter','Metal','CD',2),
('Canzone Vecchia',2015,'Sutter','Rock','CD',2),
('Canzone Vecchia',2015,'Sutter','Rock','Streaming',2),
('Songsss',2011,'Soda','Metal','Streaming',3)

SELECT * FROM Album

INSERT INTO Brano VALUES
('Aaaaa',140),
('Irene',340),
('Domani',400),
('Imagine',356),
('Fuori di testa',252),
('Assereje',371),
('Ricomincio da capo',320),
('Solita storia',418)

SELECT * FROM Brano
SELECT * FROM Album

INSERT INTO AlbumBrano VALUES
(1,1),(2,1),(1,4),(2,4),
(3,2),(4,2),(5,2),
(7,5),(8,5),(9,5),
(7,6),(8,6),(10,8), (11,7),(12,7),
(13,6),(13,4)



-------------------------------------------------------------
-------------------------- ESERCIZI -------------------------
-------------------------------------------------------------

--Restituire i titoli degli album degli '883'
SELECT DISTINCT a.Titolo
FROM Album a
JOIN Band b
ON a.BandID = b.ID
WHERE b.Nome = '883'


--Selezionare tutti gli album editi dalla casa editrice 
--nell’anno specificato
SELECT a.Titolo,a.AnnoUscita,a.CasaDiscografica,b.Nome, a.Genere,a.SupportoDistribuzione
FROM Album a
INNER JOIN Band b
ON a.BandID = b.ID
WHERE a.CasaDiscografica = 'Sutter' AND a.AnnoUscita = 2018


--Restituire tutti i titoli delle canzoni dei 'Maneskin'
--di album pubblicati prima del 2019
SELECT DISTINCT br.Titolo as 'Brano', a.Titolo as 'Album', a.AnnoUscita
FROM Band ba
JOIN Album a
ON a.BandID = ba.ID
JOIN AlbumBrano ab
ON ab.AlbumID = a.ID
JOIN Brano br
ON br.ID = ab.BranoID
WHERE ba.Nome = 'Maneskin' AND a.AnnoUscita < 2019


--Individuare tutti gli album in cui è contenuta la canzone 
--'Imagine'
SELECT DISTINCT a.Titolo as 'Album', ba.Nome as 'Band', a.AnnoUscita, 
a.CasaDiscografica, a.Genere
FROM Album a
INNER JOIN AlbumBrano ab
ON a.ID = ab.AlbumID
JOIN Brano b
ON b.ID = ab.BranoID
JOIN Band ba			-- opzionale
ON ba.ID = a.BandID		-- opzionale
WHERE b.Titolo = 'Imagine'


--Restituire il numero totale di canzoni eseguite dalla band 
--'The Giornalisti'
SELECT   COUNT(*) as 'Numero Totale Canzoni'
FROM
(
	SELECT DISTINCT br.Titolo as 'Canzone', a.Titolo as 'Album', 
		a.CasaDiscografica, a.Genere
	FROM Band ba
	JOIN Album a
	ON ba.ID = a.BandID
	JOIN AlbumBrano ab
	ON ab.AlbumID = a.ID
	JOIN Brano br
	ON br.ID = ab.BranoID
	WHERE ba.Nome = 'Maneskin'
) AS ElencoCanzoniBand 


--Contare per ogni album la somma dei minuti dei brani contenuti
SELECT a.Titolo as 'Album', SUM(b.Durata_s) as 'Durata (sec)'
FROM Album a
JOIN AlbumBrano ab
ON a.ID = ab.AlbumID
JOIN Brano b
ON b.ID = ab.BranoID
GROUP BY a.Titolo, a.AnnoUscita,a.CasaDiscografica,a.Genere




