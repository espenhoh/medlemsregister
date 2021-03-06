USE klubb;

TRUNCATE TABLE Medlem;
LOAD DATA INFILE 'C:/data/medlemmer.csv'
INTO TABLE Medlem
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
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

TRUNCATE TABLE Kontingent;
LOAD DATA INFILE 'C:/data/kontingent.csv'
INTO TABLE Kontingent
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES 
(Medlemstype, Kontingent, Periode, @Aldersgruppe)
SET Min_alder = CASE WHEN @Aldersgruppe LIKE '%+%' THEN CONVERT(LEFT(@Aldersgruppe,2), UNSIGNED INTEGER) + 1 ELSE CONVERT(LEFT(@Aldersgruppe,2), UNSIGNED INTEGER) END, -- 60 + definert som 61 og eldre
Max_alder = CASE WHEN @Aldersgruppe LIKE '%+%' THEN 9999 ELSE CONVERT(RIGHT(@Aldersgruppe,2), UNSIGNED INTEGER) END;

--Oversikt over korrekte postadresse
TRUNCATE TABLE postadresse;
LOAD DATA INFILE 'C:/data/Postnummerregister-ansi.txt'
INTO TABLE postadresse
LINES TERMINATED BY '\r\n'
(postnummer, Poststed, @ignored1,@ignored2,@ignored3);


SELECT * FROM  Medlem;
SELECT * FROM Betaling;
SELECT * FROM kontingent;
SELECT * FROM postadresse;