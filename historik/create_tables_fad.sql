
----------------------------------------------------------------------------------------
/* PRÆAMBEL */
----------------------------------------------------------------------------------------

-- Sætter search path til også at inkludere 'public' hvor postgis er installeret
SET search_path TO cvr, public;


----------------------------------------------------------------------------------------
/* CREATE TABLES */
----------------------------------------------------------------------------------------

-- Opretter stamtabel med udgangspunkt i opbygningen af LIFA's data
CREATE TABLE cvr.cvr_fad_view_stam (LIKE cvr.cvr_fad_view);

-- Sætter kombinationen cvrnr, deltagernummer som primary key i stamdatatabellen
ALTER TABLE cvr.cvr_fad_view_stam ADD PRIMARY KEY (cvrnr, deltagernummer);

-- Opretter skelet til historik-tabel for adresser
CREATE TABLE cvr.cvr_fad_view_hist_adresser (
  deltagernummer BIGINT,
  cvrnr BIGINT,
  pnr BIGINT,
  indlaest_dato DATE,
  beliggenhedsadresse_gyldigfra TIMESTAMP,
  beliggenhedsadresse_vejnavn VARCHAR(40),
  beliggenhedsadresse_vejkode BIGINT,
  beliggenhedsadresse_husnummerfra BIGINT,
  beliggenhedsadresse_husnummertil BIGINT,
  beliggenhedsadresse_bogstavfra VARCHAR(2),
  beliggenhedsadresse_bogstavtil VARCHAR(2),
  beliggenhedsadresse_etage VARCHAR(2),
  beliggenhedsadresse_sidedoer VARCHAR(4),
  beliggenhedsadresse_postnr BIGINT,
  beliggenhedsadresse_postdistrikt VARCHAR(25),
  beliggenhedsadresse_bynavn VARCHAR(34),
  beliggenhedsadresse_postboks BIGINT,
  beliggenhedsadresse_conavn varchar(40),
  beliggenhedsadresse_adressefritekst varchar(238),
  kommune_kode SMALLINT,
  kommune_tekst VARCHAR(50),
  vejkode varchar(4),
  hus_nr varchar(4),
  gid integer,
  kilde varchar(10),
  FOREIGN KEY (cvrnr, deltagernummer) REFERENCES cvr.cvr_fad_view_stam (cvrnr, deltagernummer)
);


----------------------------------------------------------------------------------------
/* LÆGGER STAMDATA I HISTORIK-TABELLEN */
----------------------------------------------------------------------------------------

-- Lægger det yngste data fra dumpet, cvr.cvr_fad_view, ind i stamtabellen
INSERT INTO cvr.cvr_fad_view_stam
  SELECT
    dump.modifikationsstatus,
    dump.deltagernummer,
    dump.ajourfoeringsdato,
    dump.deltagelsegyldigfra,
    dump.cvrnr,
    dump.pnr,
    dump.deltagertype,
    dump.navn,
    dump.personstatus,
    dump.rolle,
    dump.beliggenhedsadresse_gyldigfra,
    dump.beliggenhedsadresse_vejnavn,
    dump.beliggenhedsadresse_vejkode,
    dump.beliggenhedsadresse_husnummerfra,
    dump.beliggenhedsadresse_husnummertil,
    dump.beliggenhedsadresse_bogstavfra,
    dump.beliggenhedsadresse_bogstavtil,
    dump.beliggenhedsadresse_etage,
    dump.beliggenhedsadresse_sidedoer,
    dump.beliggenhedsadresse_postnr ,
    dump.beliggenhedsadresse_postdistrikt,
    dump.beliggenhedsadresse_bynavn,
    dump.beliggenhedsadresse_postboks,
    dump.beliggenhedsadresse_conavn,
    dump.beliggenhedsadresse_adressefritekst,
    dump.kommune_kode,
    dump.kommune_tekst,
    dump.vejkode,
    dump.hus_nr,
    dump.gid,
    dump.indlaest_dato
  FROM cvr.cvr_fad_view dump
  WHERE (dump.indlaest_dato = (SELECT MIN(indlaest_dato) FROM cvr.cvr_fad_view)); -- succes: lægger alle 382927 rækker over

-- Lægger adressedata fra stamtabellen ind i tabellen for adresse-historik
INSERT INTO cvr.cvr_fad_view_hist_adresser (
    deltagernummer,
    cvrnr,
    pnr,
    indlaest_dato,
    beliggenhedsadresse_gyldigfra,
    beliggenhedsadresse_vejnavn,
    beliggenhedsadresse_vejkode,
    beliggenhedsadresse_husnummerfra,
    beliggenhedsadresse_husnummertil,
    beliggenhedsadresse_bogstavfra,
    beliggenhedsadresse_bogstavtil,
    beliggenhedsadresse_etage,
    beliggenhedsadresse_sidedoer,
    beliggenhedsadresse_postnr,
    beliggenhedsadresse_postdistrikt,
    beliggenhedsadresse_bynavn,
    beliggenhedsadresse_postboks,
    beliggenhedsadresse_conavn,
    beliggenhedsadresse_adressefritekst,
    kommune_kode,
    kommune_tekst,
    vejkode,
    hus_nr,
    gid,
    kilde)
  SELECT
    stam.deltagernummer,
    stam.cvrnr,
    stam.pnr,
    stam.indlaest_dato,
    stam.beliggenhedsadresse_gyldigfra,
    stam.beliggenhedsadresse_vejnavn,
    stam.beliggenhedsadresse_vejkode,
    stam.beliggenhedsadresse_husnummerfra,
    stam.beliggenhedsadresse_husnummertil,
    stam.beliggenhedsadresse_bogstavfra,
    stam.beliggenhedsadresse_bogstavtil,
    stam.beliggenhedsadresse_etage,
    stam.beliggenhedsadresse_sidedoer,
    stam.beliggenhedsadresse_postnr,
    stam.beliggenhedsadresse_postdistrikt,
    stam.beliggenhedsadresse_bynavn,
    stam.beliggenhedsadresse_postboks,
    stam.beliggenhedsadresse_conavn,
    stam.beliggenhedsadresse_adressefritekst,
    stam.kommune_kode,
    stam.kommune_tekst,
    stam.vejkode,
    stam.hus_nr,
    stam.gid,
    'LIFA'
  FROM cvr.cvr_fad_view_stam stam;  -- succes: lægger alle 382927 rækker over

