WITH cvr_aktuel AS (
         SELECT cvr_prod_enhed_geo.virksomhed_cvrnr,
            cvr_prod_enhed_geo.pnr,
            cvr_prod_enhed_geo.hovedbranche_tekst,
            cvr_prod_enhed_geo.navn_tekst,
            cvr_prod_enhed_geo.kommune_kode,
            cvr_prod_enhed_geo.beliggenhedsadresse_vejnavn,
            cvr_prod_enhed_geo.belig_adresse_husnummerfra,
            cvr_prod_enhed_geo.beliggenhedsadresse_postnr,
            cvr_prod_enhed_geo.belig_adresse_postdistrikt,
            cvr_prod_enhed_geo.email_kontaktoplysning,
            cvr_prod_enhed_geo.livsforloeb_startdato
           FROM cvr.cvr_prod_enhed_geo
          WHERE cvr_prod_enhed_geo.indlaest_dato = date_trunc('month'::text, now())::date
        ), cvr_sidste_md AS (
         SELECT cvr_prod_enhed_geo.virksomhed_cvrnr,
            cvr_prod_enhed_geo.pnr,
            cvr_prod_enhed_geo.hovedbranche_tekst,
            cvr_prod_enhed_geo.navn_tekst,
            cvr_prod_enhed_geo.kommune_kode,
            cvr_prod_enhed_geo.beliggenhedsadresse_vejnavn,
            cvr_prod_enhed_geo.belig_adresse_husnummerfra,
            cvr_prod_enhed_geo.beliggenhedsadresse_postnr,
            cvr_prod_enhed_geo.belig_adresse_postdistrikt,
            cvr_prod_enhed_geo.email_kontaktoplysning,
            cvr_prod_enhed_geo.livsforloeb_startdato
           FROM cvr.cvr_prod_enhed_geo
          WHERE cvr_prod_enhed_geo.indlaest_dato = date_trunc('month'::text, now() - '1 mon'::interval)::date
        )
 SELECT 'Tilflytter'::text AS flyttemoenster,
    a.virksomhed_cvrnr,
    a.pnr,
    a.hovedbranche_tekst,
    a.navn_tekst,
    a.kommune_kode,
    a.beliggenhedsadresse_vejnavn,
    a.belig_adresse_husnummerfra,
    a.beliggenhedsadresse_postnr,
    a.belig_adresse_postdistrikt,
    a.email_kontaktoplysning,
    a.livsforloeb_startdato
   FROM cvr_aktuel a
     LEFT JOIN cvr_sidste_md b ON a.pnr = b.pnr
  WHERE a.kommune_kode = 151 AND a.kommune_kode <> b.kommune_kode
UNION
 SELECT 'Fraflytter'::text AS flyttemoenster,
    a.virksomhed_cvrnr,
    a.pnr,
    a.hovedbranche_tekst,
    a.navn_tekst,
    a.kommune_kode,
    a.beliggenhedsadresse_vejnavn,
    a.belig_adresse_husnummerfra,
    a.beliggenhedsadresse_postnr,
    a.belig_adresse_postdistrikt,
    a.email_kontaktoplysning,
    a.livsforloeb_startdato
   FROM cvr_aktuel a
     RIGHT JOIN cvr_sidste_md b ON a.pnr = b.pnr
  WHERE b.kommune_kode = 151 AND a.kommune_kode <> b.kommune_kode
UNION
 SELECT 'Nystartet'::text AS flyttemoenster,
    a.virksomhed_cvrnr,
    a.pnr,
    a.hovedbranche_tekst,
    a.navn_tekst,
    a.kommune_kode,
    a.beliggenhedsadresse_vejnavn,
    a.belig_adresse_husnummerfra,
    a.beliggenhedsadresse_postnr,
    a.belig_adresse_postdistrikt,
    a.email_kontaktoplysning,
    a.livsforloeb_startdato
   FROM cvr_aktuel a
  WHERE a.kommune_kode = 151 AND a.livsforloeb_startdato > date_trunc('month'::text, now() - '1 mon'::interval)::date
UNION
 SELECT 'Ophørt'::text AS flyttemoenster,
    b.virksomhed_cvrnr,
    b.pnr,
    b.hovedbranche_tekst,
    b.navn_tekst,
    b.kommune_kode,
    b.beliggenhedsadresse_vejnavn,
    b.belig_adresse_husnummerfra,
    b.beliggenhedsadresse_postnr,
    b.belig_adresse_postdistrikt,
    b.email_kontaktoplysning,
    b.livsforloeb_startdato
   FROM cvr_aktuel a
     RIGHT JOIN cvr_sidste_md b ON a.pnr = b.pnr
  WHERE b.kommune_kode = 151 AND a.pnr IS NULL
