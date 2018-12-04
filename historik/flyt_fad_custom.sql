CREATE OR REPLACE FUNCTION cvr.flyt_fad_custom(komkode integer, startdato date, slutdato date)
  RETURNS TABLE(
    status text,
    "cvr-nummer" bigint,
    "p-nummer" bigint,
    aktivitetsdato timestamp without time zone,
    virksomhedsnavn character varying,
    vejnavn character varying,
    husnummer bigint,
    postnummer bigint,
    by character varying,
    kommunekode smallint,
    kommune character varying,
    "antal ansatte" integer,
    branchegruppekode varchar(1),
    branchegruppe character varying,
    hovedbranchekode integer,
    hovedbranche character varying,
    "selskabsform-kode" smallint,
    selskabsform character varying,
    "gammel vejnavn" character varying,
    "gammel husnummer" bigint,
    "gammel postnummer" bigint,
    "gammel by" character varying,
    "gammel kommunekode" smallint,
    "gammel kommune" character varying,
    startdato timestamp without time zone,
    telefonnummer character varying,
    emailadresse character varying,
    "fuldt ansvarlige deltagere" character varying,
    reklamebeskyttelse boolean,
    geom geometry)
LANGUAGE SQL
AS $$
SELECT
  flyt.flyttemoenster,
  stam.virksomhed_cvrnr,
  flyt.pnr,
  flyt.aktivitetsdato,
  stam.navn_tekst,
  flyt.beliggenhedsadresse_vejnavn,
  flyt.belig_adresse_husnummerfra,
  flyt.beliggenhedsadresse_postnr,
  stam.beliggenhedsadresse_bynavn,
  flyt.kommune_kode,
  stam.kommune_tekst,
  stam.aarsbes_antalansatte,
  hovedbranche_noegle.branche,
  hovedbranche_noegle.branchenavn,
  stam.hovedbranche_kode,
  stam.hovedbranche_tekst,
  stam_jur.virksomhedsform_kode,
  stam_jur.virksomhedsform_tekst,
  flyt.gammel_vejnavn,
  flyt.gammel_husnummer,
  flyt.gammel_postnr,
  flyt.gammel_bynavn,
  flyt.gammel_kommunekode,
  flyt.gammel_kommune,
  stam.livsforloeb_startdato,
  stam.telefonnummer_kontaktoplysning,
  stam.email_kontaktoplysning,
  fad.fuldt_ansvarlige_deltagere,
  stam.reklamebeskyttelse,
  flyt.geom

FROM (
       SELECT 'Tilflytter'::text AS flyttemoenster,
            a.pnr,
            a.kommune_kode,
            a.beliggenhedsadresse_gyldigfra AS "aktivitetsdato",
            a.beliggenhedsadresse_vejnavn,
            a.belig_adresse_husnummerfra,
            a.beliggenhedsadresse_postnr,
            a.belig_adresse_postdistrikt,
            b.beliggenhedsadresse_vejnavn AS "gammel_vejnavn",
            b.belig_adresse_husnummerfra AS "gammel_husnummer",
            b.beliggenhedsadresse_postnr AS "gammel_postnr",
            b.beliggenhedsadresse_bynavn AS "gammel_bynavn",
            b.kommune_kode AS "gammel_kommunekode",
            b.kommune_tekst AS "gammel_kommune",
            a.geom,
            a.indlaest_dato
        FROM (
               SELECT
                 pnr,
                 beliggenhedsadresse_gyldigfra,
                 kommune_kode,
                 beliggenhedsadresse_vejnavn,
                 belig_adresse_husnummerfra,
                 beliggenhedsadresse_postnr,
                 belig_adresse_postdistrikt,
                 geom,
                 indlaest_dato
               FROM cvr.cvr_prod_enhed_geo_hist_adresser
               WHERE beliggenhedsadresse_gyldigfra BETWEEN startdato AND slutdato
             ) AS a
          LEFT JOIN (
                       SELECT
                          pnr,
                          beliggenhedsadresse_gyldigfra,
                          beliggenhedsadresse_vejnavn,
                          belig_adresse_husnummerfra,
                          beliggenhedsadresse_postnr,
                          beliggenhedsadresse_bynavn,
                          kommune_kode,
                          kommune_tekst,
                          belig_adresse_postdistrikt,
						              geom,
                          indlaest_dato
                       FROM cvr.cvr_prod_enhed_geo_hist_adresser c
                       WHERE beliggenhedsadresse_gyldigfra = (
                         SELECT MAX(beliggenhedsadresse_gyldigfra)
                         FROM cvr.cvr_prod_enhed_geo_hist_adresser d
                         WHERE c.pnr = d.pnr AND d.beliggenhedsadresse_gyldigfra < startdato
                       )
                     ) AS b ON a.pnr = b.pnr
          WHERE a.kommune_kode = komkode AND a.kommune_kode <> b.kommune_kode

        UNION ALL

        SELECT 'Fraflytter'::text AS flyttemoenster,
          a.pnr,
          a.kommune_kode,
          a.beliggenhedsadresse_gyldigfra AS "aktivitetsdato",
          a.beliggenhedsadresse_vejnavn,
          a.belig_adresse_husnummerfra,
          a.beliggenhedsadresse_postnr,
          a.belig_adresse_postdistrikt,
          b.beliggenhedsadresse_vejnavn AS "gammel_vejnavn",
          b.belig_adresse_husnummerfra AS "gammel_husnummer",
          b.beliggenhedsadresse_postnr AS "gammel_postnr",
          b.beliggenhedsadresse_bynavn AS "gammel_bynavn",
          b.kommune_kode AS "gammel_kommunekode",
          b.kommune_tekst AS "gammel_kommune",
		      a.geom,
          a.indlaest_dato
        FROM (
               SELECT
                 pnr,
                 beliggenhedsadresse_gyldigfra,
                 beliggenhedsadresse_vejnavn,
                 belig_adresse_husnummerfra,
                 beliggenhedsadresse_postnr,
                 beliggenhedsadresse_bynavn,
                 kommune_kode,
                 kommune_tekst,
                 belig_adresse_postdistrikt,
		  		       geom,
                 indlaest_dato
               FROM cvr.cvr_prod_enhed_geo_hist_adresser
               WHERE beliggenhedsadresse_gyldigfra BETWEEN startdato AND slutdato
             ) AS a
          LEFT JOIN (
                      SELECT
                        pnr,
                        beliggenhedsadresse_gyldigfra,
                        beliggenhedsadresse_vejnavn,
                        belig_adresse_husnummerfra,
                        beliggenhedsadresse_postnr,
                        beliggenhedsadresse_bynavn,
                        kommune_kode,
                        kommune_tekst,
                        belig_adresse_postdistrikt,
		  				          geom,
                        indlaest_dato
                      FROM cvr.cvr_prod_enhed_geo_hist_adresser c
                      WHERE beliggenhedsadresse_gyldigfra = (
                        SELECT MAX(beliggenhedsadresse_gyldigfra)
                        FROM cvr.cvr_prod_enhed_geo_hist_adresser d
                        WHERE c.pnr = d.pnr AND d.beliggenhedsadresse_gyldigfra < startdato
                      )
                     ) AS b ON a.pnr = b.pnr
        WHERE b.kommune_kode = komkode AND a.kommune_kode <> b.kommune_kode

        UNION ALL

        SELECT 'Nystartet'::text AS flyttemoenster,
          a.pnr,
          a.kommune_kode,
          a.beliggenhedsadresse_gyldigfra AS "aktivitetsdato",
          a.beliggenhedsadresse_vejnavn,
          a.belig_adresse_husnummerfra,
          a.beliggenhedsadresse_postnr,
          a.belig_adresse_postdistrikt,
          NULL AS "gammel_vejnavn",
          NULL AS "gammel_husnummer",
          NULL AS "gammel_postnr",
          NULL AS "gammel_bynavn",
          NULL AS "gammel_kommunekode",
          NULL AS "gammel_kommune",
          a.geom,
          a.indlaest_dato
        FROM cvr.cvr_prod_enhed_geo_stam a
        WHERE a.kommune_kode = komkode AND a.livsforloeb_startdato BETWEEN startdato AND slutdato

        UNION ALL

        SELECT 'Ophørt'::text AS flyttemoenster,
          a.pnr,
          a.kommune_kode,
          a.livsforloeb_ophoersdato AS "aktivitetsdato",
          a.beliggenhedsadresse_vejnavn,
          a.belig_adresse_husnummerfra,
          a.beliggenhedsadresse_postnr,
          a.belig_adresse_postdistrikt,
          NULL AS "gammel_vejnavn",
          NULL AS "gammel_husnummer",
          NULL AS "gammel_postnr",
          NULL AS "gammel_bynavn",
          NULL AS "gammel_kommunekode",
          NULL AS "gammel_kommune",
          a.geom,
          a.indlaest_dato
        FROM cvr.cvr_prod_enhed_geo_stam a
        WHERE a.kommune_kode = komkode AND a.livsforloeb_ophoersdato BETWEEN startdato AND slutdato) AS flyt

JOIN cvr.cvr_prod_enhed_geo_stam stam ON flyt.pnr = stam.pnr

LEFT JOIN cvr.cvr_jur_enhed_geo_stam stam_jur ON stam.virksomhed_cvrnr = stam_jur.cvrnr

LEFT JOIN cvr.hovedbranche_noegle hovedbranche_noegle ON LEFT(stam.hovedbranche_kode::text, -4) = hovedbranche_noegle.kode::text

LEFT JOIN (SELECT substr(array_agg(navn)::text, 2, length(array_agg(navn)::text)-2) AS fuldt_ansvarlige_deltagere,
                  cvrnr
           FROM (SELECT DISTINCT navn, cvrnr FROM cvr.cvr_fad) AS navne_tabel
           GROUP BY cvrnr) AS fad
           ON fad.cvrnr = stam.virksomhed_cvrnr

ORDER BY flyt.flyttemoenster

$$;

