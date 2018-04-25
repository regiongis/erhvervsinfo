CREATE OR REPLACE FUNCTION cvr.update_tables_fad() RETURNS void AS $$

----------------------------------------------------------------------------------------
/* OPDATERER STAMTABEL */
----------------------------------------------------------------------------------------

-- Opdaterer eksisterende p-enheder i tabellen med data fra LIFA
UPDATE cvr.cvr_fad_view_stam AS stam
  SET
    stam.modifikationsstatus = dump.modifikationsstatus,
    stam.deltagernummer = dump.deltagernummer,
    stam.ajourfoeringsdato = dump.ajourfoeringsdato,
    stam.deltagelsegyldigfra = dump.deltagelsegyldigfra,
    stam.cvrnr = dump.cvrnr,
    stam.pnr = dump.pnr,
    stam.deltagertype = dump.deltagertype,
    stam.navn = dump.navn,
    stam.personstatus = dump.personstatus,
    stam.rolle = dump.rolle,
    stam.beliggenhedsadresse_gyldigfra = dump.beliggenhedsadresse_gyldigfra,
    stam.beliggenhedsadresse_vejnavn = dump.beliggenhedsadresse_vejnavn,
    stam.beliggenhedsadresse_vejkode = dump.beliggenhedsadresse_vejkode,
    stam.beliggenhedsadresse_husnummerfra = dump.beliggenhedsadresse_husnummerfra,
    stam.beliggenhedsadresse_husnummertil = dump.beliggenhedsadresse_husnummertil,
    stam.beliggenhedsadresse_bogstavfra = dump.beliggenhedsadresse_bogstavfra,
    stam.beliggenhedsadresse_bogstavtil = dump.beliggenhedsadresse_bogstavtil,
    stam.beliggenhedsadresse_etage = dump.beliggenhedsadresse_etage,
    stam.beliggenhedsadresse_sidedoer = dump.beliggenhedsadresse_sidedoer,
    stam.beliggenhedsadresse_postnr = dump.beliggenhedsadresse_postnr,
    stam.beliggenhedsadresse_postdistrikt = dump.beliggenhedsadresse_postdistrikt,
    stam.beliggenhedsadresse_bynavn = dump.beliggenhedsadresse_bynavn,
    stam.beliggenhedsadresse_postboks = dump.beliggenhedsadresse_postboks,
    stam.beliggenhedsadresse_conavn = dump.beliggenhedsadresse_conavn,
    stam.beliggenhedsadresse_adressefritekst = dump.beliggenhedsadresse_adressefritekst,
    stam.kommune_kode = dump.kommune_kode,
    stam.kommune_tekst = dump.kommune_tekst,
    stam.vejkode = dump.vejkode,
    stam.hus_nr = dump.hus_nr,
    stam.gid = dump.gid,
    stam.indlaest_dato = dump.indlaest_dato
  FROM cvr.cvr_fad_view dump
  WHERE (stam.cvrnr = dump.cvrnr
  AND stam.deltagernummer = dump.deltagernummer
  --AND dump.indlaest_dato = '2017-02-01' -- disse datoer skal bruges til den første opsætning, og det er alle datoerne, som hverken er ældst eller yngst. Datoerne findes med querien: SELECT COUNT(*), indlaest_dato FROM cvr.cvr_fad_view GROUP BY indlaest_dato;
  AND dump.indlaest_dato = (SELECT MAX(cvr.cvr_fad_view.indlaest_dato) FROM cvr.cvr_fad_view)
);


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
    dump.beliggenhedsadresse_postnr,
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
  FROM cvr.cvr_fad_view_stam stam
  RIGHT JOIN cvr.cvr_fad_view dump ON stam.cvrnr = dump.cvrnr AND stam.deltagernummer = dump.deltagernummer -- note: joiner med to kolonner som keys
  WHERE (stam.cvrnr IS NULL
  AND stam.deltagernummer IS NULL -- note: joiner med to kolonner som keys
  --AND dump.indlaest_dato = '2017-02-01' -- disse datoer skal bruges til den første opsætning, og det er alle datoerne, som hverken er ældst eller yngst. Datoerne findes med querien: SELECT COUNT(*), indlaest_dato FROM cvr.cvr_fad_view GROUP BY indlaest_dato;
  AND dump.indlaest_dato = (SELECT MAX(cvr.cvr_fad_view.indlaest_dato) FROM cvr.cvr_fad_view)
);

----------------------------------------------------------------------------------------
/* HISTORIK FOR ADRESSER */
----------------------------------------------------------------------------------------

-- Tilføjer nye p-enheder i tabellen cvr_fad_view_hist_adresser
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
  FROM cvr.cvr_fad_view_stam stam
  LEFT JOIN cvr.cvr_fad_view_hist_adresser ON stam.cvrnr = cvr.cvr_fad_view_hist_adresser.cvrnr AND stam.deltagernummer = cvr.cvr_fad_view_hist_adresser.deltagernummer  -- note: joiner med to kolonner som keys
  WHERE cvr.cvr_fad_view_hist_adresser.cvrnr IS NULL
  AND cvr.cvr_fad_view_hist_adresser.deltagernummer IS NULL; -- note: joiner med to kolonner som keys
  --AND stam.beliggenhedsadresse_gyldigfra IS NOT NULL -- note: foreløbigt unødvendig


-- Tilføjer nye adresser til eksisterende p-enheder i tabellen cvr_fad_view_hist_adresser
WITH cvr_fad_view_hist_adresser_nyeste AS (
  SELECT cvrnr, deltagernummer, MAX(indlaest_dato) AS adresse_dato
  FROM cvr.cvr_fad_view_hist_adresser
  GROUP BY cvr.cvr_fad_view_hist_adresser.cvrnr, cvr.cvr_fad_view_hist_adresser.deltagernummer) -- note: grupperer på de kolonner, der bruges til primary keys
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
  FROM cvr.cvr_fad_view_stam stam
  INNER JOIN cvr.cvr_fad_view_hist_adresser ON stam.cvrnr = cvr.cvr_fad_view_hist_adresser.cvrnr AND stam.deltagernummer = cvr.cvr_fad_view_hist_adresser.deltagernummer -- note: joiner med to kolonner som keys
  INNER JOIN cvr_fad_view_hist_adresser_nyeste ON stam.cvrnr = cvr_fad_view_hist_adresser_nyeste.cvrnr AND stam.deltagernummer = cvr_fad_view_hist_adresser_nyeste.deltagernummer -- note: joiner med to kolonner som keys
  WHERE ((cvr.cvr_fad_view_hist_adresser.indlaest_dato = cvr_fad_view_hist_adresser_nyeste.adresse_dato)
  AND  (COALESCE(stam.beliggenhedsadresse_vejkode::text, '') ||
       COALESCE(stam.beliggenhedsadresse_husnummerfra::text, '') ||
       COALESCE(stam.beliggenhedsadresse_postnr::text, '') ||
       COALESCE(stam.beliggenhedsadresse_bogstavfra::text, '') ||
       COALESCE(stam.beliggenhedsadresse_etage::text, '') ||
       COALESCE(stam.beliggenhedsadresse_sidedoer::text, '') !=
       COALESCE(cvr.cvr_fad_view_hist_adresser.beliggenhedsadresse_vejkode::text, '') ||
       COALESCE(cvr.cvr_fad_view_hist_adresser.beliggenhedsadresse_husnummerfra::text, '') ||
       COALESCE(cvr.cvr_fad_view_hist_adresser.beliggenhedsadresse_postnr::text, '') ||
       COALESCE(cvr.cvr_fad_view_hist_adresser.beliggenhedsadresse_bogstavfra::text, '') ||
       COALESCE(cvr.cvr_fad_view_hist_adresser.beliggenhedsadresse_etage::text, '') ||
       COALESCE(cvr.cvr_fad_view_hist_adresser.beliggenhedsadresse_sidedoer::text, '')));


----------------------------------------------------------------------------------------
/* REFRESH MATERIALIZED VIEWS */
----------------------------------------------------------------------------------------	   

REFRESH MATERIALIZED VIEW cvr.cvr_fad_adresser;

$$ LANGUAGE SQL;
