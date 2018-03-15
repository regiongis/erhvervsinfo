
CREATE MATERIALIZED VIEW cvr.cvr_fad_adresser AS
SELECT
  stam.modifikationsstatus,
  stam.deltagernummer,
  stam.ajourfoeringsdato,
  stam.deltagelsegyldigfra,
  stam.cvrnr,
  stam.pnr,
  stam.deltagertype,
  stam.id,
  stam.navn,
  stam.personstatus,
  stam.rolle,
  hist.indlaest_dato,
  hist.beliggenhedsadresse_gyldigfra,
  hist.beliggenhedsadresse_vejnavn,
  hist.beliggenhedsadresse_vejkode,
  hist.beliggenhedsadresse_husnummerfra,
  hist.beliggenhedsadresse_husnummertil,
  hist.beliggenhedsadresse_bogstavfra,
  hist.beliggenhedsadresse_bogstavtil,
  hist.beliggenhedsadresse_etage,
  hist.beliggenhedsadresse_sidedoer,
  hist.beliggenhedsadresse_postnr,
  hist.beliggenhedsadresse_postdistrikt,
  hist.beliggenhedsadresse_bynavn,
  hist.beliggenhedsadresse_postboks,
  hist.beliggenhedsadresse_conavn,
  hist.beliggenhedsadresse_adressefritekst,
  hist.kommune_kode,
  hist.kommune_tekst,
  hist.vejkode,
  hist.hus_nr,
  hist.gid,
  hist.kilde
  FROM cvr.cvr_fad_view_stam stam
FULL OUTER JOIN cvr.cvr_fad_view_hist_adresser hist ON stam.cvrnr = hist.cvrnr AND stam.deltagernummer = hist.deltagernummer;


