
----------------------------------------------------------------------------------------
/* PRÆAMBEL */
----------------------------------------------------------------------------------------

-- Sætter search path til også at inkludere 'public' hvor postgis er installeret
SET search_path TO cvr, public;


----------------------------------------------------------------------------------------
/* CREATE TABLES */
----------------------------------------------------------------------------------------

CREATE TABLE cvr.cvr_prod_enhed_geo_stam (LIKE cvr.cvr_prod_enhed_geo);

CREATE TABLE cvr.cvr_prod_enhed_geo_hist_adresser (
  pnr BIGINT,
  indlaest_dato DATE,
  beliggenhedsadresse_gyldigfra TIMESTAMP,
  beliggenhedsadresse_vejnavn VARCHAR(40),
  beliggenhedsadresse_vejkode BIGINT,
  belig_adresse_husnummerfra BIGINT,
  belig_adresse_husnummertil BIGINT,
  beliggenhedsadresse_bogstavfra VARCHAR(2),
  beliggenhedsadresse_bogstavtil VARCHAR(2),
  beliggenhedsadresse_etage VARCHAR(2),
  beliggenhedsadresse_sidedoer VARCHAR(4),
  beliggenhedsadresse_postnr BIGINT,
  belig_adresse_postdistrikt VARCHAR(25),
  beliggenhedsadresse_bynavn VARCHAR(34),
  kommune_kode SMALLINT,
  kommune_tekst VARCHAR(50),
  beliggenhedsadresse_postboks BIGINT,
  beliggenhedsadresse_conavn VARCHAR(40),
  belig_adresse_adr_fritekst VARCHAR(238),

  tilnaermethusnr VARCHAR(4),
  geokodningskvalitet VARCHAR(100),
  koornord DOUBLE PRECISION,
  kooroest DOUBLE PRECISION,
  lat DOUBLE PRECISION,
  long DOUBLE PRECISION,
  vejkod VARCHAR(4),
  husnr VARCHAR(4),
  vejkode VARCHAR(4),
  hus_nr VARCHAR(4),
  lifasystemid INTEGER,
  geom GEOMETRY(Point,25832),
  gid INTEGER,

  kilde VARCHAR(10)
);

CREATE TABLE cvr.cvr_prod_enhed_geo_hist_hovedbranche (
  pnr BIGINT,
  indlaest_dato DATE,
  hovedbranche_gyldigfra TIMESTAMP,
  hovedbranche_kode INT,
  hovedbranche_tekst VARCHAR(130),
  kilde VARCHAR(10)
);

CREATE TABLE cvr.cvr_prod_enhed_geo_hist_ansatte_aar (
  pnr BIGINT,
  indlaest_dato DATE,
  aarsbeskaeftigelse_aar SMALLINT,
  aarsbes_antalansatte INT,
  aarsbes_antansatteinterval VARCHAR(100),
  aarsbes_antalaarsvaerk INT,
  aarsbes_antaarsvaerkinterval VARCHAR(100),
  aarsbes_antalinclejere INT,
  aarsbes_antinclejereinterval VARCHAR(100),
  kilde VARCHAR(10)
);

CREATE TABLE cvr.cvr_prod_enhed_geo_hist_ansatte_kvartal (
  pnr BIGINT,
  indlaest_dato DATE,
  kvartalsbeskaeftigelse_aar SMALLINT,
  kvartalsbeskaeftigelse_kvartal SMALLINT,
  kvartalsbeskaeftigelse_antalansatte INT,
  kvartalsbeskaeftigelse_antalansatteinterval VARCHAR(300),
  kvartalsbeskaeftigelse_antalaarsvaerk INT,
  kvartalsbeskaeftigelse_antalaarsvaerkinterval VARCHAR(300),
  kilde VARCHAR(10)
);

CREATE SEQUENCE gid_seq START 2000000001;


----------------------------------------------------------------------------------------
/* LÆGGER STAMDATA I HISTORIK-TABELLERNE */
----------------------------------------------------------------------------------------

INSERT INTO cvr.cvr_prod_enhed_geo_stam
  SELECT
    dump.modifikationsstatus,
    dump.pnr,
    dump.livsforloeb_startdato,
    dump.livsforloeb_ophoersdato,
    dump.ajourfoeringsdato,
    dump.virksomhed_gyldigfra,
    dump.virksomhed_cvrnr,
    dump.reklamebeskyttelse,
    dump.navn_gyldigfra,
    dump.navn_tekst,
    dump.beliggenhedsadresse_gyldigfra,
    dump.beliggenhedsadresse_vejnavn,
    dump.beliggenhedsadresse_vejkode,
    dump.belig_adresse_husnummerfra,
    dump.belig_adresse_husnummertil,
    dump.beliggenhedsadresse_bogstavfra,
    dump.beliggenhedsadresse_bogstavtil,
    dump.beliggenhedsadresse_etage,
    dump.beliggenhedsadresse_sidedoer,
    dump.beliggenhedsadresse_postnr,
    dump.belig_adresse_postdistrikt,
    dump.beliggenhedsadresse_bynavn,
    dump.kommune_kode,
    dump.kommune_tekst,
    dump.beliggenhedsadresse_postboks,
    dump.beliggenhedsadresse_conavn,
    dump.belig_adresse_adr_fritekst,
    dump.postadresse_gyldigfra,
    dump.postadresse_vejnavn,
    dump.postadresse_vejkode,
    dump.postadresse_husnummerfra,
    dump.postadresse_husnummertil,
    dump.postadresse_bogstavfra,
    dump.postadresse_bogstavtil,
    dump.postadresse_etage,
    dump.postadresse_sidedoer,
    dump.postadresse_postnr,
    dump.postadresse_postdistrikt,
    dump.postadresse_bynavn,
    dump.postadresse_kommune_kode,
    dump.postadresse_kommune_tekst,
    dump.postadresse_postboks,
    dump.postadresse_conavn,
    dump.postadresse_adressefritekst,
    dump.hovedbranche_gyldigfra,
    dump.hovedbranche_kode,
    dump.hovedbranche_tekst,
    dump.bibranche1_gyldigfra,
    dump.bibranche1_kode,
    dump.bibranche1_tekst,
    dump.bibranche2_gyldigfra,
    dump.bibranche2_kode,
    dump.bibranche2_tekst,
    dump.bibranche3_gyldigfra,
    dump.bibranche3_kode,
    dump.bibranche3_tekst,
    dump.telefonnummer_gyldigfra,
    dump.telefonnummer_kontaktoplysning,
    dump.telefax_gyldigfra,
    dump.telefax_kontaktoplysning,
    dump.email_gyldigfra,
    dump.email_kontaktoplysning,
    dump.aarsbeskaeftigelse_aar,
    dump.aarsbes_antalansatte,
    dump.aarsbes_antansatteinterval,
    dump.aarsbes_antalaarsvaerk,
    dump.aarsbes_antaarsvaerkinterval,
    dump.aarsbes_antalinclejere,
    dump.aarsbes_antinclejereinterval,
    dump.kvartalsbeskaeftigelse_aar,
    dump.kvartalsbeskaeftigelse_kvartal,
    dump.kvartalsbeskaeftigelse_antalansatte,
    dump.kvartalsbeskaeftigelse_antalansatteinterval,
    dump.kvartalsbeskaeftigelse_antalaarsvaerk,
    dump.kvartalsbeskaeftigelse_antalaarsvaerkinterval,
    dump.maanedsbeskaeftigelse_aar,
    dump.maanedsbeskaeftigelse_maaned,
    dump.maanedsbeskaeftigelse_antalansatte,
    dump.maanedsbeskaeftigelse_antalansatteinterval,
    dump.maanedsbeskaeftigelse_antalaarsvaerk,
    dump.maanedsbeskaeftigelse_antalaarsvaerkinterval,
    dump.hovedafdeling,
    dump.deltagere,
    dump.tilnaermethusnr,
    dump.geokodningskvalitet,
    dump.koornord,
    dump.kooroest,
    dump.lat,
    dump.long,
    dump.vejkod,
    dump.husnr,
    dump.vejkode,
    dump.hus_nr,
    dump.lifasystemid,
    dump.indlaest_dato,
    dump.geom,
    dump.gid
  FROM cvr.cvr_prod_enhed_geo dump
  WHERE (dump.indlaest_dato = (SELECT MIN(indlaest_dato) FROM cvr.cvr_prod_enhed_geo));

INSERT INTO cvr.cvr_prod_enhed_geo_hist_adresser (
    pnr,
    indlaest_dato,
    beliggenhedsadresse_gyldigfra,
    beliggenhedsadresse_vejnavn,
    beliggenhedsadresse_vejkode,
    belig_adresse_husnummerfra,
    belig_adresse_husnummertil,
    beliggenhedsadresse_bogstavfra,
    beliggenhedsadresse_bogstavtil,
    beliggenhedsadresse_etage,
    beliggenhedsadresse_sidedoer,
    beliggenhedsadresse_postnr,
    belig_adresse_postdistrikt,
    beliggenhedsadresse_bynavn,
    kommune_kode,
    kommune_tekst,
    beliggenhedsadresse_postboks,
    beliggenhedsadresse_conavn,
    belig_adresse_adr_fritekst,
    tilnaermethusnr,
    geokodningskvalitet,
    koornord,
    kooroest,
    lat,
    long,
    vejkod,
    husnr,
    vejkode,
    hus_nr,
    lifasystemid,
    geom,
    gid,
    kilde)
  SELECT
    stam.pnr,
    stam.indlaest_dato,
    stam.beliggenhedsadresse_gyldigfra,
    stam.beliggenhedsadresse_vejnavn,
    stam.beliggenhedsadresse_vejkode,
    stam.belig_adresse_husnummerfra,
    stam.belig_adresse_husnummertil,
    stam.beliggenhedsadresse_bogstavfra,
    stam.beliggenhedsadresse_bogstavtil,
    stam.beliggenhedsadresse_etage,
    stam.beliggenhedsadresse_sidedoer,
    stam.beliggenhedsadresse_postnr,
    stam.belig_adresse_postdistrikt,
    stam.beliggenhedsadresse_bynavn,
    stam.kommune_kode,
    stam.kommune_tekst,
    stam.beliggenhedsadresse_postboks,
    stam.beliggenhedsadresse_conavn,
    stam.belig_adresse_adr_fritekst,
    stam.tilnaermethusnr,
    stam.geokodningskvalitet,
    stam.koornord,
    stam.kooroest,
    stam.lat,
    stam.long,
    stam.vejkod,
    stam.husnr,
    stam.vejkode,
    stam.hus_nr,
    stam.lifasystemid,
    stam.geom,
    stam.gid,
    'LIFA'
  FROM cvr.cvr_prod_enhed_geo_stam stam;

INSERT INTO cvr.cvr_prod_enhed_geo_hist_hovedbranche (
    pnr,
    indlaest_dato,
    hovedbranche_gyldigfra,
    hovedbranche_kode,
    hovedbranche_tekst,
    kilde)
  SELECT
    stam.pnr,
    stam.indlaest_dato,
    stam.hovedbranche_gyldigfra,
    stam.hovedbranche_kode,
    stam.hovedbranche_tekst,
    'LIFA'
  FROM cvr.cvr_prod_enhed_geo_stam stam;

INSERT INTO cvr.cvr_prod_enhed_geo_hist_ansatte_aar (
    pnr,
    indlaest_dato,
    aarsbeskaeftigelse_aar,
    aarsbes_antalansatte,
    aarsbes_antansatteinterval,
    aarsbes_antalaarsvaerk,
    aarsbes_antaarsvaerkinterval,
    aarsbes_antalinclejere,
    aarsbes_antinclejereinterval,
    kilde)
  SELECT
    stam.pnr,
    stam.indlaest_dato,
    stam.aarsbeskaeftigelse_aar,
    stam.aarsbes_antalansatte,
    stam.aarsbes_antansatteinterval,
    stam.aarsbes_antalaarsvaerk,
    stam.aarsbes_antaarsvaerkinterval,
    stam.aarsbes_antalinclejere,
    stam.aarsbes_antinclejereinterval,
    'LIFA'
  FROM cvr.cvr_prod_enhed_geo_stam stam;

INSERT INTO cvr.cvr_prod_enhed_geo_hist_ansatte_kvartal (
    pnr,
    indlaest_dato,
    kvartalsbeskaeftigelse_aar,
    kvartalsbeskaeftigelse_kvartal,
    kvartalsbeskaeftigelse_antalansatte,
    kvartalsbeskaeftigelse_antalansatteinterval,
    kvartalsbeskaeftigelse_antalaarsvaerk,
    kvartalsbeskaeftigelse_antalaarsvaerkinterval,
    kilde)
  SELECT
    stam.pnr,
    stam.indlaest_dato,
    stam.kvartalsbeskaeftigelse_aar,
    stam.kvartalsbeskaeftigelse_kvartal,
    stam.kvartalsbeskaeftigelse_antalansatte,
    stam.kvartalsbeskaeftigelse_antalansatteinterval,
    stam.kvartalsbeskaeftigelse_antalaarsvaerk,
    stam.kvartalsbeskaeftigelse_antalaarsvaerkinterval,
    'LIFA'
  FROM cvr.cvr_prod_enhed_geo_stam stam;

