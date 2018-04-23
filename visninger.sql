--- Feil i fødselsdato og andre feil
CREATE VIEW v_andre_feil AS
SELECT --Duplikater i medlemsnummer
	Medlemsnummer,
	Fornavn,
	Etternavn,
	'Ikke unikt medlemsnummer' AS Feiltype
FROM medlem WHERE Medlemsnummer in (SELECT Medlemsnummer FROM medlem GROUP BY Medlemsnummer HAVING COUNT(*) > 1)
UNION ALL
SELECT -- Ugyldig fødselsdato
	Medlemsnummer,
	Fornavn,
	Etternavn,
	CONCAT('Feil format Fødselsdato: ', Fodselsdato)  AS Feiltype
FROM medlem WHERE STR_TO_DATE(Fodselsdato, '%d.%m.%Y') IS NULL
UNION ALL
SELECT --Fødselsdato frem i tid
	Medlemsnummer,
	Fornavn,
	Etternavn,
	CONCAT('Fødselsdato frem i tid: ', Fodselsdato)  AS Feiltype
FROM medlem WHERE DATEDIFF(STR_TO_DATE(Fodselsdato, '%d.%m.%Y'), NOW()) > 0
UNION ALL
SELECT --Lever personen?
	Medlemsnummer,
	Fornavn,
	Etternavn,
	CONCAT('Er medlem i live? Alder: ', TIMESTAMPDIFF(YEAR, STR_TO_DATE(medlem.Fodselsdato, '%d.%m.%Y'), NOW()), ' år. ')  AS Feiltype
FROM medlem WHERE TIMESTAMPDIFF(YEAR, STR_TO_DATE(medlem.Fodselsdato, '%d.%m.%Y'), NOW()) > 85
UNION ALL
SELECT --MAnglende felter
	Medlemsnummer,
	Fornavn,
	Etternavn,
	CONCAT('Manglende felter: ',
		CASE WHEN COALESCE(Fornavn, '') = '' THEN 'Fornavn ' ELSE '' END,
		CASE WHEN COALESCE(Etternavn, '') = '' THEN 'Etternavn ' ELSE '' END,
		CASE WHEN COALESCE(Fodselsdato, '') = '' THEN 'Fødselsdato ' ELSE '' END,
		CASE WHEN COALESCE(Kjonn, '') = '' THEN 'Kjønn ' ELSE '' END,
		CASE WHEN COALESCE(Medlemstype, '') = '' THEN 'Medlemstype ' ELSE '' END,
		CASE WHEN COALESCE(Gateaddresse, '') = '' THEN 'Gateaddresse ' ELSE '' END,
		CASE WHEN COALESCE(Postnummer, '') = '' THEN 'Postnummer ' ELSE '' END,
		CASE WHEN COALESCE(Poststed, '') = '' THEN 'Poststed ' ELSE '' END
	) AS Feiltype
FROM medlem WHERE 
	COALESCE(Fornavn, '') = '' OR COALESCE(Etternavn, '') = ''
	OR COALESCE(Fodselsdato, '') = '' OR COALESCE(Kjonn, '') = ''
	OR COALESCE(Medlemstype, '') = '' OR COALESCE(Gateaddresse, '') = ''
	OR COALESCE(Postnummer, '') = '' OR COALESCE(Poststed, '') = ''
UNION ALL
SELECT -- Postnummer som ikke eksisterer
	medlem.Medlemsnummer,
	medlem.Fornavn,
	medlem.Etternavn,
	CONCAT('Feil i postnummer: ', medlem.Postnummer)  AS Feiltype
FROM medlem
LEFT JOIN postadresser on postadresser.Postnummer = medlem.Postnummer
WHERE postadresser.Postnummer IS NULL
UNION ALL
SELECT
	medlem.Medlemsnummer,
	medlem.Fornavn,
	medlem.Etternavn,
	CONCAT('Feil i poststed: "', medlem.Poststed, '" skal være "', postadresser.Poststed, '"')  AS Feiltype
FROM medlem
LEFT JOIN postadresser on postadresser.Postnummer = medlem.Postnummer
WHERE medlem.Poststed <> postadresser.Poststed;

SELECT * FROM v_andre_feil;


-- Feil medlemstype
CREATE VIEW v_feil_medlemstype AS
WITH alder AS (
 SELECT 
 	Medlem_id,
 	COALESCE(TIMESTAMPDIFF(YEAR, STR_TO_DATE(medlem.Fodselsdato, '%d.%m.%Y'), NOW()), 0) as Alder --MySQL spesifikk funksjon
 FROM medlem)
SELECT
	medlem.Medlemsnummer,
	medlem.Fornavn,
	medlem.Etternavn,
	alder.alder AS Alder,
	medlem.Medlemstype AS Registrert_medlemstype,
	CASE WHEN kontingent.Medlemstype IS NULL THEN 'Kontroller fødselsdato!' ELSE kontingent.Medlemstype END AS Korrekt_medlemstype
FROM medlem
JOIN alder on alder.Medlem_id = medlem.Medlem_id
LEFT JOIN kontingent on alder.Alder >= kontingent.Min_alder AND alder.Alder <= kontingent.Max_alder
LEFT JOIN kontingent k2 on kontingent.Periode < k2.Periode   --Kun siste periode
WHERE k2.Periode IS NULL
AND medlem.Medlemstype <> kontingent.Medlemstype
OR kontingent.Medlemstype IS NULL;


SELECT * FROM v_feil_medlemstype;


---Gale innbetalinger, kontrollerer opp mot faktisk medlemstype
CREATE VIEW v_gale_innbetalinger as
SELECT
	betaling.Medlemsnummer,
	medlem.Fornavn,
	medlem.Etternavn,
	medlem.Medlemstype,
	betaling.Belop as innbetalt,
	kontingent.Kontingent AS Korrekt_kontingent
FROM betaling
JOIN medlem on betaling.Medlemsnummer = medlem.Medlemsnummer
LEFT JOIN	kontingent on kontingent.Periode = betaling.Periode AND kontingent.Medlemstype = medlem.Medlemstype
WHERE medlem.Medlemsnummer NOT in (SELECT Medlemsnummer FROM medlem GROUP BY Medlemsnummer HAVING COUNT(*) > 1) AND betaling.Belop <> kontingent.Kontingent;
--Legg til betalinger gjort av medlem '42'

SELECT * FROM v_gale_innbetalinger;

--Betalinger utført av medlemmer med ikke unikt medemsnummer
CREATE VIEW v_gale_innbetalinger_medlemsnr as
SELECT
	Medlemsnummer,
	Belop AS Beløp,
	Periode,
	Innbetalt_dato as Innbetalt_dato
FROM betaling
WHERE betaling.Medlemsnummer in (SELECT Medlemsnummer FROM medlem GROUP BY Medlemsnummer HAVING COUNT(*) > 1);

SELECT * FROM v_gale_innbetalinger_medlemsnr;


-- Gale innbetalinger som følge av feil medlemstype
CREATE VIEW v_gale_innbetalinger_korrigert_medlemstype as
SELECT
	betaling.Medlemsnummer,
	v_feil_medlemstype.Fornavn,
	v_feil_medlemstype.Etternavn,
	v_feil_medlemstype.Korrekt_medlemstype,
	betaling.Belop as innbetalt,
	kontingent.Kontingent AS Korrekt_kontingent
FROM betaling
JOIN v_feil_medlemstype on betaling.Medlemsnummer = v_feil_medlemstype.Medlemsnummer
LEFT JOIN	kontingent on kontingent.Periode = betaling.Periode AND kontingent.Medlemstype = v_feil_medlemstype.Korrekt_medlemstype
WHERE v_feil_medlemstype.Medlemsnummer NOT in (SELECT Medlemsnummer FROM medlem GROUP BY Medlemsnummer HAVING COUNT(*) > 1) AND betaling.Belop <> kontingent.Kontingent;


SELECT * FROM  v_gale_innbetalinger_korrigert_medlemstype;

CREATE VIEW v_alle_medlemmer AS
SELECT
	Medlemsnummer,
	Fornavn,
	Etternavn,
	COALESCE(TIMESTAMPDIFF(YEAR, STR_TO_DATE(medlem.Fodselsdato, '%d.%m.%Y'), NOW()), 0) as Alder,
	Kjonn AS Kjønn,
	Gateaddresse,
	RIGHT(CONCAT('000',COALESCE(Postnummer,'')),4) as Postnummer,
	Poststed,
	Medlemstype
FROM medlem;

