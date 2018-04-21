USE klubb;

TRUNCATE TABLE Medlem;
LOAD DATA INFILE 'C:/data/medlemmer.csv'
INTO TABLE Medlem
FIELDS TERMINATED BY ';'
IGNORE 1 LINES 
(Medlemsnummer, Fornavn, Etternavn, Fodselsdato, Kjonn, Medlemstype, Gateaddresse, Postnummer, Poststed);

TRUNCATE TABLE Betaling;
LOAD DATA INFILE 'C:/data/betalinger.csv'
INTO TABLE Betaling
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES 
(Medlemsnummer, Belop, Periode, @var_Innbetalt_dato)
SET Innbetalt_dato = STR_TO_DATE(@var_Innbetalt_dato, '%d.%m.%Y');

--SET Fodselsdato = STR_TO_DATE(@Fdato, '%d.%m.%Y')


SELECT * FROM  Medlem;
SELECT * FROM Betaling;