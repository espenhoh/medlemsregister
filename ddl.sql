DROP SCHEMA klubb;

CREATE SCHEMA klubb;

USE klubb;


CREATE TABLE Betaling (
  Betaling_id    Integer UNSIGNED NOT NULL AUTO_INCREMENT,
  Medlemsnummer  Integer UNSIGNED NOT NULL,
  Belop          Numeric(18, 4),
  Periode        YEAR(4),      ---Spesialtype
  Innbetalt_dato Date, 
  PRIMARY KEY (
      Betaling_id
  )
) ;
ALTER TABLE Betaling COMMENT = '';
CREATE TABLE Kontingent (
  kontingent_id Integer UNSIGNED NOT NULL AUTO_INCREMENT,
  Medlemstype   VarChar(10),
  Kontingent    Numeric(18, 4),
  Periode       YEAR(4),      ---Spesialtype
  Min_alder     SmallInt UNSIGNED,
  Max_alder     SmallInt UNSIGNED, 
  PRIMARY KEY (
      kontingent_id
  )
) ;
ALTER TABLE Kontingent COMMENT = '';
CREATE TABLE Medlem (
  Medlem_id     Integer UNSIGNED NOT NULL AUTO_INCREMENT,
  Medlemsnummer Integer UNSIGNED NOT NULL,
  Fornavn       VarChar(20),
  Etternavn     VarChar(20),
  Fodselsdato   Char(10),   --For � tillate alle feil � leses inn
  Kjonn         Char(1),
  Gateaddresse  VarChar(30),
  Postnummer    SmallInt UNSIGNED,
  Poststed      VarChar(20),
  Medlemstype   VarChar(20), 
  PRIMARY KEY (
      Medlem_id
  )
) ;
ALTER TABLE Medlem COMMENT = '';

