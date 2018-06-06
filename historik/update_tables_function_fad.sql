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
/* REFRESH MATERIALIZED VIEWS */
----------------------------------------------------------------------------------------	   

REFRESH MATERIALIZED VIEW cvr.cvr_fad_adresser;

$$ LANGUAGE SQL;
