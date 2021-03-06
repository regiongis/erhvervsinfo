CREATE OR REPLACE FUNCTION cvr.update_tables_jur() RETURNS void AS $$

----------------------------------------------------------------------------------------
/* OPDATERER STAMTABEL */
----------------------------------------------------------------------------------------

-- Opdaterer eksisterende p-enheder i tabellen med data fra LIFA
UPDATE cvr.cvr_jur_enhed_geo_stam AS stam
  SET
    modifikationsstatus = dump.modifikationsstatus,
    cvrnr = dump.cvrnr,
    livsforloeb_startdato = dump.livsforloeb_startdato,
    livsforloeb_ophoersdato = dump.livsforloeb_ophoersdato,
    ajourfoeringsdato = dump.ajourfoeringsdato,
    reklamebeskyttelse = dump.reklamebeskyttelse,
    navn_gyldigfra = dump.navn_gyldigfra,
    navn_tekst = dump.navn_tekst,
    beliggenhedsadresse_gyldigfra = dump.beliggenhedsadresse_gyldigfra,
    beliggenhedsadresse_vejnavn = dump.beliggenhedsadresse_vejnavn,
    beliggenhedsadresse_vejkode = dump.beliggenhedsadresse_vejkode,
    belig_adresse_husnummerfra = dump.belig_adresse_husnummerfra,
    belig_adresse_husnummertil = dump.belig_adresse_husnummertil,
    beliggenhedsadresse_bogstavfra = dump.beliggenhedsadresse_bogstavfra,
    beliggenhedsadresse_bogstavtil = dump.beliggenhedsadresse_bogstavtil,
    beliggenhedsadresse_etage = dump.beliggenhedsadresse_etage,
    beliggenhedsadresse_sidedoer = dump.beliggenhedsadresse_sidedoer,
    beliggenhedsadresse_postnr = dump.beliggenhedsadresse_postnr,
    belig_adresse_postdistrikt = dump.belig_adresse_postdistrikt,
    beliggenhedsadresse_bynavn = dump.beliggenhedsadresse_bynavn,
    kommune_kode = dump.kommune_kode,
    kommune_tekst = dump.kommune_tekst,
    beliggenhedsadresse_postboks = dump.beliggenhedsadresse_postboks,
    beliggenhedsadresse_conavn = dump.beliggenhedsadresse_conavn,
    belig_adresse_adr_fritekst = dump.belig_adresse_adr_fritekst,
    postadresse_gyldigfra = dump.postadresse_gyldigfra,
    postadresse_vejnavn = dump.postadresse_vejnavn,
    postadresse_vejkode = dump.postadresse_vejkode,
    postadresse_husnummerfra = dump.postadresse_husnummerfra,
    postadresse_husnummertil = dump.postadresse_husnummertil,
    postadresse_bogstavfra = dump.postadresse_bogstavfra,
    postadresse_bogstavtil = dump.postadresse_bogstavtil,
    postadresse_etage = dump.postadresse_etage,
    postadresse_sidedoer = dump.postadresse_sidedoer,
    postadresse_postnr = dump.postadresse_postnr,
    postadresse_postdistrikt = dump.postadresse_postdistrikt,
    postadresse_bynavn = dump.postadresse_bynavn,
    postadresse_kommune_kode = dump.postadresse_kommune_kode,
    postadresse_kommune_tekst = dump.postadresse_kommune_tekst,
    postadresse_postboks = dump.postadresse_postboks,
    postadresse_conavn = dump.postadresse_conavn,
    postadresse_adressefritekst = dump.postadresse_adressefritekst,
    virksomhedsform_gyldigfra = dump.virksomhedsform_gyldigfra,
    virksomhedsform_kode = dump.virksomhedsform_kode,
    virksomhedsform_tekst = dump.virksomhedsform_tekst,
    virk_form_ans_datalev = dump.virk_form_ans_datalev,
    hovedbranche_gyldigfra = dump.hovedbranche_gyldigfra,
    hovedbranche_kode = dump.hovedbranche_kode,
    hovedbranche_tekst = dump.hovedbranche_tekst,
    bibranche1_gyldigfra = dump.bibranche1_gyldigfra,
    bibranche1_kode = dump.bibranche1_kode,
    bibranche1_tekst = dump.bibranche1_tekst,
    bibranche2_gyldigfra = dump.bibranche2_gyldigfra,
    bibranche2_kode = dump.bibranche2_kode,
    bibranche2_tekst = dump.bibranche2_tekst,
    bibranche3_gyldigfra = dump.bibranche3_gyldigfra,
    bibranche3_kode = dump.bibranche3_kode,
    bibranche3_tekst = dump.bibranche3_tekst,
    telefonnummer_gyldigfra = dump.telefonnummer_gyldigfra,
    telefonnummer_kontaktoplysning = dump.telefonnummer_kontaktoplysning,
    telefax_gyldigfra = dump.telefax_gyldigfra,
    telefax_kontaktoplysning = dump.telefax_kontaktoplysning,
    email_gyldigfra = dump.email_gyldigfra,
    email_kontaktoplysning = dump.email_kontaktoplysning,
    kreditoplysning_gyldigfra = dump.kreditoplysning_gyldigfra,
    kreditoplysning_tekst = dump.kreditoplysning_tekst,
    aarsbeskaeftigelse_aar = dump.aarsbeskaeftigelse_aar,
    aarsbes_antalansatte = dump.aarsbes_antalansatte,
    aarsbes_antansatteinterval = dump.aarsbes_antansatteinterval,
    aarsbes_antalaarsvaerk = dump.aarsbes_antalaarsvaerk,
    aarsbes_antaarsvaerkinterval = dump.aarsbes_antaarsvaerkinterval,
    aarsbes_antalinclejere = dump.aarsbes_antalinclejere,
    aarsbes_antinclejereinterval = dump.aarsbes_antinclejereinterval,
    kvartalsbeskaeftigelse_aar = dump.kvartalsbeskaeftigelse_aar,
    kvartalsbeskaeftigelse_kvartal = dump.kvartalsbeskaeftigelse_kvartal,
    kvartalsbes_antansatte = dump.kvartalsbes_antansatte,
    kvartalsbes_antansatteinterval = dump.kvartalsbes_antansatteinterval,
    kvartalsbes_antalaarsvaerk = dump.kvartalsbes_antalaarsvaerk,
    kvartalsbes_antaarsvaerkinterval = dump.kvartalsbes_antaarsvaerkinterval,
    maanedsbeskaeftigelse_aar = dump.maanedsbeskaeftigelse_aar,
    maanedsbeskaeftigelse_maaned = dump.maanedsbeskaeftigelse_maaned,
    maanedsbeskaeftigelse_antalansatte = dump.maanedsbeskaeftigelse_antalansatte,
    maanedsbeskaeftigelse_antalansatteinterval = dump.maanedsbeskaeftigelse_antalansatteinterval,
    maanedsbeskaeftigelse_antalaarsvaerk = dump.maanedsbeskaeftigelse_antalaarsvaerk,
    maanedsbeskaeftigelse_antalaarsvaerkinterval = dump.maanedsbeskaeftigelse_antalaarsvaerkinterval,
    produktionsenheder = dump.produktionsenheder,
    deltagere = dump.deltagere,
    produktionsenheder_gyldigfra = dump.produktionsenheder_gyldigfra,
    tilnaermethusnr = dump.tilnaermethusnr,
    geokodningskvalitet = dump.geokodningskvalitet,
    koornord = dump.koornord,
    kooroest = dump.kooroest,
    lat = dump.lat,
    long = dump.long,
    vejkode = dump.vejkode,
    hus_nr = dump.hus_nr,
    husnr = dump.husnr,
    adr2 = dump.adr2,
    lifasystemid = dump.lifasystemid,
    indlaest_dato = dump.indlaest_dato,
    geom = dump.geom,
    gid = dump.gid
  FROM cvr.cvr_jur_enhed_geo dump
  WHERE (stam.cvrnr = dump.cvrnr
  --AND dump.indlaest_dato = '2018-08-31' -- disse datoer skal bruges til den første opsætning, og det er alle datoerne, som hverken er ældst eller yngst. Datoerne findes med querien: SELECT COUNT(*), indlaest_dato FROM cvr.cvr_jur_enhed_geo GROUP BY indlaest_dato;
  --AND dump.indlaest_dato = '2018-09-20'
  --AND dump.indlaest_dato = '2018-10-02'
  AND dump.indlaest_dato = (SELECT MAX(cvr.cvr_jur_enhed_geo.indlaest_dato) FROM cvr.cvr_jur_enhed_geo)
);



INSERT INTO cvr.cvr_jur_enhed_geo_stam
  SELECT
    dump.modifikationsstatus,
    dump.cvrnr,
    dump.livsforloeb_startdato,
    dump.livsforloeb_ophoersdato,
    dump.ajourfoeringsdato,
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
    dump.virksomhedsform_gyldigfra,
    dump.virksomhedsform_kode,
    dump.virksomhedsform_tekst,
    dump.virk_form_ans_datalev,
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
    dump.kreditoplysning_gyldigfra,
    dump.kreditoplysning_tekst,
    dump.aarsbeskaeftigelse_aar,
    dump.aarsbes_antalansatte,
    dump.aarsbes_antansatteinterval,
    dump.aarsbes_antalaarsvaerk,
    dump.aarsbes_antaarsvaerkinterval,
    dump.aarsbes_antalinclejere,
    dump.aarsbes_antinclejereinterval,
    dump.kvartalsbeskaeftigelse_aar,
    dump.kvartalsbeskaeftigelse_kvartal,
    dump.kvartalsbes_antansatte,
    dump.kvartalsbes_antansatteinterval,
    dump.kvartalsbes_antalaarsvaerk,
    dump.kvartalsbes_antaarsvaerkinterval,
    dump.maanedsbeskaeftigelse_aar,
    dump.maanedsbeskaeftigelse_maaned,
    dump.maanedsbeskaeftigelse_antalansatte,
    dump.maanedsbeskaeftigelse_antalansatteinterval,
    dump.maanedsbeskaeftigelse_antalaarsvaerk,
    dump.maanedsbeskaeftigelse_antalaarsvaerkinterval,
    dump.produktionsenheder,
    dump.deltagere,
    dump.produktionsenheder_gyldigfra,
    dump.tilnaermethusnr,
    dump.geokodningskvalitet,
    dump.koornord,
    dump.kooroest,
    dump.lat,
    dump.long,
    dump.vejkode,
    dump.hus_nr,
    dump.husnr,
    dump.adr2,
    dump.lifasystemid,
    dump.indlaest_dato,
    dump.geom,
    dump.gid
  FROM cvr.cvr_jur_enhed_geo_stam stam
  RIGHT JOIN cvr.cvr_jur_enhed_geo dump ON stam.cvrnr = dump.cvrnr
  WHERE (stam.cvrnr IS NULL
  --AND dump.indlaest_dato = '2018-08-31' -- disse datoer skal bruges til den første opsætning, og det er alle datoerne, som hverken er ældst eller yngst. Datoerne findes med querien: SELECT COUNT(*), indlaest_dato FROM cvr.cvr_jur_enhed_geo GROUP BY indlaest_dato;
  --AND dump.indlaest_dato = '2018-09-20'
  --AND dump.indlaest_dato = '2018-10-02'
  AND dump.indlaest_dato = (SELECT MAX(cvr.cvr_jur_enhed_geo.indlaest_dato) FROM cvr.cvr_jur_enhed_geo)
);

----------------------------------------------------------------------------------------
/* HISTORIK FOR ADRESSER */
----------------------------------------------------------------------------------------

-- Tilføjer nye p-enheder i tabellen cvr_jur_enhed_geo_hist_adresser
INSERT INTO cvr.cvr_jur_enhed_geo_hist_adresser (
    cvrnr,
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
    vejkode,
    hus_nr,
    husnr,
    adr2,
    lifasystemid,
    geom,
    gid,
    kilde)
  SELECT
    stam.cvrnr,
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
    stam.vejkode,
    stam.hus_nr,
    stam.husnr,
    stam.adr2,
    stam.lifasystemid,
    stam.geom,
    stam.gid,
    'LIFA'
  FROM cvr.cvr_jur_enhed_geo_stam stam
  LEFT JOIN cvr.cvr_jur_enhed_geo_hist_adresser ON stam.cvrnr = cvr.cvr_jur_enhed_geo_hist_adresser.cvrnr
  WHERE cvr.cvr_jur_enhed_geo_hist_adresser.cvrnr IS NULL
  AND stam.beliggenhedsadresse_gyldigfra IS NOT NULL;

-- Tilføjer nye adresser til eksisterende p-enheder i tabellen cvr_jur_enhed_geo_hist_adresser
WITH cvr_jur_enhed_geo_hist_adresser_nyeste AS (
  SELECT cvrnr, MAX(indlaest_dato) AS adresse_dato
  FROM cvr.cvr_jur_enhed_geo_hist_adresser
  GROUP BY cvr.cvr_jur_enhed_geo_hist_adresser.cvrnr)
INSERT INTO cvr.cvr_jur_enhed_geo_hist_adresser (
    cvrnr,
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
    vejkode,
    hus_nr,
    husnr,
    adr2,
    lifasystemid,
    geom,
    gid,
    kilde)
  SELECT
    stam.cvrnr,
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
    stam.vejkode,
    stam.hus_nr,
    stam.husnr,
    stam.adr2,
    stam.lifasystemid,
    stam.geom,
    stam.gid,
    'LIFA'
  FROM cvr.cvr_jur_enhed_geo_stam stam
  INNER JOIN cvr.cvr_jur_enhed_geo_hist_adresser ON stam.cvrnr = cvr.cvr_jur_enhed_geo_hist_adresser.cvrnr
  INNER JOIN cvr_jur_enhed_geo_hist_adresser_nyeste ON stam.cvrnr = cvr_jur_enhed_geo_hist_adresser_nyeste.cvrnr
  WHERE ((cvr.cvr_jur_enhed_geo_hist_adresser.indlaest_dato = cvr_jur_enhed_geo_hist_adresser_nyeste.adresse_dato)
  AND  (COALESCE(stam.beliggenhedsadresse_vejkode::text, '') ||
       COALESCE(stam.belig_adresse_husnummerfra::text, '') ||
       COALESCE(stam.beliggenhedsadresse_postnr::text, '') ||
       COALESCE(stam.beliggenhedsadresse_bogstavfra::text, '') ||
       COALESCE(stam.beliggenhedsadresse_etage::text, '') ||
       COALESCE(stam.beliggenhedsadresse_sidedoer::text, '') !=
       COALESCE(cvr.cvr_jur_enhed_geo_hist_adresser.beliggenhedsadresse_vejkode::text, '') ||
       COALESCE(cvr.cvr_jur_enhed_geo_hist_adresser.belig_adresse_husnummerfra::text, '') ||
       COALESCE(cvr.cvr_jur_enhed_geo_hist_adresser.beliggenhedsadresse_postnr::text, '') ||
       COALESCE(cvr.cvr_jur_enhed_geo_hist_adresser.beliggenhedsadresse_bogstavfra::text, '') ||
       COALESCE(cvr.cvr_jur_enhed_geo_hist_adresser.beliggenhedsadresse_etage::text, '') ||
       COALESCE(cvr.cvr_jur_enhed_geo_hist_adresser.beliggenhedsadresse_sidedoer::text, '')));


----------------------------------------------------------------------------------------
/* HISTORIK FOR HOVEDBRANCHE */
----------------------------------------------------------------------------------------

-- Tilføjer nye p-enheder i tabellen cvr_jur_enhed_geo_hist_hovedbranche
INSERT INTO cvr.cvr_jur_enhed_geo_hist_hovedbranche(
    cvrnr,
    indlaest_dato,
    hovedbranche_gyldigfra,
    hovedbranche_kode,
    hovedbranche_tekst,
    kilde)
  SELECT
    stam.cvrnr,
    stam.indlaest_dato,
    stam.hovedbranche_gyldigfra,
    stam.hovedbranche_kode,
    stam.hovedbranche_tekst,
    'LIFA'
  FROM cvr.cvr_jur_enhed_geo_stam stam
  LEFT JOIN cvr.cvr_jur_enhed_geo_hist_hovedbranche ON stam.cvrnr = cvr.cvr_jur_enhed_geo_hist_hovedbranche.cvrnr
  WHERE cvr.cvr_jur_enhed_geo_hist_hovedbranche.cvrnr IS NULL
  AND stam.hovedbranche_gyldigfra IS NOT NULL; -- note: ny linje

-- Tilføjer ændret hovedbranche til eksisterende p-enheder i tabellen cvr_jur_enhed_geo_hist_hovedbranche
WITH cvr_jur_enhed_geo_hist_hovedbranche_nyeste AS (
  SELECT cvrnr, MAX(indlaest_dato) AS hovedbranche_dato
  FROM cvr.cvr_jur_enhed_geo_hist_hovedbranche
  GROUP BY cvr.cvr_jur_enhed_geo_hist_hovedbranche.cvrnr)
INSERT INTO cvr.cvr_jur_enhed_geo_hist_hovedbranche(
    cvrnr,
    indlaest_dato,
    hovedbranche_gyldigfra,
    hovedbranche_kode,
    hovedbranche_tekst,
    kilde)
  SELECT
    stam.cvrnr,
    stam.indlaest_dato,
    stam.hovedbranche_gyldigfra,
    stam.hovedbranche_kode,
    stam.hovedbranche_tekst,
    'LIFA'
  FROM cvr.cvr_jur_enhed_geo_stam stam
  INNER JOIN cvr.cvr_jur_enhed_geo_hist_hovedbranche ON stam.cvrnr = cvr.cvr_jur_enhed_geo_hist_hovedbranche.cvrnr
  INNER JOIN cvr_jur_enhed_geo_hist_hovedbranche_nyeste ON stam.cvrnr = cvr_jur_enhed_geo_hist_hovedbranche_nyeste.cvrnr
  WHERE ((cvr.cvr_jur_enhed_geo_hist_hovedbranche.indlaest_dato = cvr_jur_enhed_geo_hist_hovedbranche_nyeste.hovedbranche_dato)
  AND   ((cvr.cvr_jur_enhed_geo_hist_hovedbranche.hovedbranche_kode != stam.hovedbranche_kode) OR
        (cvr.cvr_jur_enhed_geo_hist_hovedbranche.hovedbranche_tekst != stam.hovedbranche_tekst)));


----------------------------------------------------------------------------------------
/* HISTORIK FOR ANTAL ANSATTE (AAR) */
----------------------------------------------------------------------------------------

-- Tilføjer nye p-enheder i tabellen cvr_jur_enhed_geo_hist_ansatte_aar
INSERT INTO cvr.cvr_jur_enhed_geo_hist_ansatte_aar (
    cvrnr,
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
    stam.cvrnr,
    stam.indlaest_dato,
    stam.aarsbeskaeftigelse_aar,
    stam.aarsbes_antalansatte,
    stam.aarsbes_antansatteinterval,
    stam.aarsbes_antalaarsvaerk,
    stam.aarsbes_antaarsvaerkinterval,
    stam.aarsbes_antalinclejere,
    stam.aarsbes_antinclejereinterval,
    'LIFA'
  FROM cvr.cvr_jur_enhed_geo_stam stam
  LEFT JOIN cvr.cvr_jur_enhed_geo_hist_ansatte_aar ON stam.cvrnr = cvr.cvr_jur_enhed_geo_hist_ansatte_aar.cvrnr
  WHERE cvr.cvr_jur_enhed_geo_hist_ansatte_aar.cvrnr IS NULL
  AND stam.aarsbeskaeftigelse_aar IS NOT NULL;


-- Opdaterer de rækker i historiktabellen, hvor der er kommet nye beskæftigelsesdata for et (pnr, aarbeskæftigelse_aar), som allerede står i historik-tabellen
UPDATE cvr.cvr_jur_enhed_geo_hist_ansatte_aar hist
  SET
    cvrnr = stam.cvrnr,
    indlaest_dato = stam.indlaest_dato,
    aarsbeskaeftigelse_aar = stam.aarsbeskaeftigelse_aar,
    aarsbes_antalansatte = stam.aarsbes_antalansatte,
    aarsbes_antansatteinterval = stam.aarsbes_antansatteinterval,
    aarsbes_antalaarsvaerk = stam.aarsbes_antalaarsvaerk,
    aarsbes_antaarsvaerkinterval = stam.aarsbes_antaarsvaerkinterval,
    aarsbes_antalinclejere = stam.aarsbes_antalinclejere,
    aarsbes_antinclejereinterval = stam.aarsbes_antinclejereinterval,
    kilde = 'LIFA'
  FROM cvr.cvr_jur_enhed_geo_stam stam
  WHERE (hist.cvrnr = stam.cvrnr)
  AND   (hist.aarsbeskaeftigelse_aar = stam.aarsbeskaeftigelse_aar)
  AND   ((hist.aarsbes_antalansatte != stam.aarsbes_antalansatte) OR
        (hist.aarsbes_antalaarsvaerk != stam.aarsbes_antalaarsvaerk) OR
        (hist.aarsbes_antalinclejere != stam.aarsbes_antalinclejere));


-- Tilføjer ændret antal ansatte til eksisterende p-enheder i tabellen cvr_jur_enhed_geo_hist_ansatte_aar
WITH cvr_jur_enhed_geo_hist_ansatte_aar_nyeste AS (
  SELECT cvrnr, MAX(indlaest_dato) AS ansatte_dato
  FROM cvr.cvr_jur_enhed_geo_hist_ansatte_aar
  GROUP BY cvr.cvr_jur_enhed_geo_hist_ansatte_aar.cvrnr)
INSERT INTO cvr.cvr_jur_enhed_geo_hist_ansatte_aar (
    cvrnr,
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
    stam.cvrnr,
    stam.indlaest_dato,
    stam.aarsbeskaeftigelse_aar,
    stam.aarsbes_antalansatte,
    stam.aarsbes_antansatteinterval,
    stam.aarsbes_antalaarsvaerk,
    stam.aarsbes_antaarsvaerkinterval,
    stam.aarsbes_antalinclejere,
    stam.aarsbes_antinclejereinterval,
    'LIFA'
  FROM cvr.cvr_jur_enhed_geo_stam stam
  INNER JOIN cvr.cvr_jur_enhed_geo_hist_ansatte_aar ON stam.cvrnr = cvr.cvr_jur_enhed_geo_hist_ansatte_aar.cvrnr
  INNER JOIN cvr_jur_enhed_geo_hist_ansatte_aar_nyeste ON stam.cvrnr = cvr_jur_enhed_geo_hist_ansatte_aar_nyeste.cvrnr
  WHERE ((cvr.cvr_jur_enhed_geo_hist_ansatte_aar.indlaest_dato = cvr_jur_enhed_geo_hist_ansatte_aar_nyeste.ansatte_dato)
  AND   cvr.cvr_jur_enhed_geo_hist_ansatte_aar.aarsbeskaeftigelse_aar != stam.aarsbeskaeftigelse_aar);


----------------------------------------------------------------------------------------
/* HISTORIK FOR ANTAL ANSATTE (KVARTAL) */
----------------------------------------------------------------------------------------

-- Tilføjer nye p-enheder i tabellen cvr_jur_enhed_geo_hist_ansatte_kvartal
INSERT INTO cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal (
    cvrnr,
    indlaest_dato,
    kvartalsbeskaeftigelse_aar,
    kvartalsbeskaeftigelse_kvartal,
    kvartalsbes_antansatte,
    kvartalsbes_antansatteinterval,
    kvartalsbes_antalaarsvaerk,
    kvartalsbes_antaarsvaerkinterval,
    kilde)
  SELECT
    stam.cvrnr,
    stam.indlaest_dato,
    stam.kvartalsbeskaeftigelse_aar,
    stam.kvartalsbeskaeftigelse_kvartal,
    stam.kvartalsbes_antansatte,
    stam.kvartalsbes_antansatteinterval,
    stam.kvartalsbes_antalaarsvaerk,
    stam.kvartalsbes_antaarsvaerkinterval,
    'LIFA'
  FROM cvr.cvr_jur_enhed_geo_stam stam
  LEFT JOIN cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal ON stam.cvrnr = cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal.cvrnr
  WHERE cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal.cvrnr IS NULL
  AND stam.kvartalsbeskaeftigelse_aar IS NOT NULL
  AND stam.kvartalsbeskaeftigelse_kvartal IS NOT NULL;


-- Opdaterer de rækker i historiktabellen, hvor der er kommet nye beskæftigelsesdata for et (pnr, aarbeskæftigelse_aar, kvartalsbeskaeftigelse_kvartal), som allerede står i historik-tabellen
UPDATE cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal hist
  SET
    cvrnr = stam.cvrnr,
    indlaest_dato = stam.indlaest_dato,
    kvartalsbeskaeftigelse_aar = stam.kvartalsbeskaeftigelse_aar,
    kvartalsbeskaeftigelse_kvartal = stam.kvartalsbeskaeftigelse_kvartal,
    kvartalsbes_antansatte = stam.kvartalsbes_antansatte,
    kvartalsbes_antansatteinterval = stam.kvartalsbes_antansatteinterval,
    kvartalsbes_antalaarsvaerk = stam.kvartalsbes_antalaarsvaerk,
    kvartalsbes_antaarsvaerkinterval = stam.kvartalsbes_antaarsvaerkinterval,
    kilde = 'LIFA'
  FROM cvr.cvr_jur_enhed_geo_stam stam
  WHERE (hist.cvrnr = stam.cvrnr)
  AND   (hist.kvartalsbeskaeftigelse_aar = stam.kvartalsbeskaeftigelse_aar)
  AND   (hist.kvartalsbeskaeftigelse_kvartal = stam.kvartalsbeskaeftigelse_kvartal)
  AND   ((hist.kvartalsbes_antansatte != stam.kvartalsbes_antansatte) OR
        (hist.kvartalsbes_antalaarsvaerk != stam.kvartalsbes_antalaarsvaerk));


-- Tilføjer ændret antal ansatte til eksisterende p-enheder i tabellen cvr_jur_enhed_geo_hist_ansatte_kvartal
WITH cvr_jur_enhed_geo_hist_ansatte_kvartal_nyeste AS (
  SELECT cvrnr, MAX(indlaest_dato) AS ansatte_dato
  FROM cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal
  GROUP BY cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal.cvrnr)
INSERT INTO cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal (
    cvrnr,
    indlaest_dato,
    kvartalsbeskaeftigelse_aar,
    kvartalsbeskaeftigelse_kvartal,
    kvartalsbes_antansatte,
    kvartalsbes_antansatteinterval,
    kvartalsbes_antalaarsvaerk,
    kvartalsbes_antaarsvaerkinterval,
    kilde)
  SELECT
    stam.cvrnr,
    stam.indlaest_dato,
    stam.kvartalsbeskaeftigelse_aar,
    stam.kvartalsbeskaeftigelse_kvartal,
    stam.kvartalsbes_antansatte,
    stam.kvartalsbes_antansatteinterval,
    stam.kvartalsbes_antalaarsvaerk,
    stam.kvartalsbes_antaarsvaerkinterval,
    'LIFA'
  FROM cvr.cvr_jur_enhed_geo_stam stam
  INNER JOIN cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal ON stam.cvrnr = cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal.cvrnr
  INNER JOIN cvr_jur_enhed_geo_hist_ansatte_kvartal_nyeste ON stam.cvrnr = cvr_jur_enhed_geo_hist_ansatte_kvartal_nyeste.cvrnr
  WHERE  ((cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal.indlaest_dato = cvr_jur_enhed_geo_hist_ansatte_kvartal_nyeste.ansatte_dato)
  AND    ((cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal.kvartalsbeskaeftigelse_aar != stam.kvartalsbeskaeftigelse_aar) OR
         (cvr.cvr_jur_enhed_geo_hist_ansatte_kvartal.kvartalsbeskaeftigelse_kvartal != stam.kvartalsbeskaeftigelse_kvartal)));

----------------------------------------------------------------------------------------
/* REFRESH MATERIALIZED VIEWS */
----------------------------------------------------------------------------------------

-- REFRESH MATERIALIZED VIEW cvr.cvr_jur_adresser;
-- REFRESH MATERIALIZED VIEW cvr.cvr_jur_ansatte_aar;
-- REFRESH MATERIALIZED VIEW cvr.cvr_jur_ansatte_kvartal;
-- REFRESH MATERIALIZED VIEW cvr.cvr_jur_hovedbranche;

$$ LANGUAGE SQL;
