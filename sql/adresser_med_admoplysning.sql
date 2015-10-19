CREATE MATERIALIZED VIEW _00_grundkort.adresser_adm_rh2 AS 
 SELECT 
    adr.the_geom,
    adr.adr_id,
    adr.komnr "Kommunenummer",
    adr.komnavn "Kommunenavn",
    adr.vejkode "Vejkode",
    adr.vejnavn "Vejnavn",
    adr.vejpresent "Vejnavn 2",
    adr.husnr "Husnummer",
    adr.postnr "Postnummer",
    adr.postnavn "Postnavn",
    adr.sognnr "Sognnnr",
    adr.sognnavn "Sognnavn",
    adr.bynavn "Bynavn",
    adr.kn100mdk,
    adr.kn1kmdk,
    adr.kn10kmdk,
    bebyg.feat_type AS "Bebyggelsestype",
    erh.plannavn AS "Lokalplannavn",
    erh.plannr AS "Lokalplannr",
    erh.anvendelsespecifik AS "Lokalplan anvendelsespecifik",
    erh.zonestatus AS "Lokalplan zonestatus",
    erh.doklink AS "Lokalplan link"
   FROM (SELECT the_geom,
	    adr_id,
	    komnr,
	    komnavn,
	    vejkode,
	    vejnavn,
	    vejpresent,
	    husnr,
	    postnr,
	    postnavn,
	    sognnr,
	    sognnavn,
	    bynavn,
	    kn100mdk,
	    kn1kmdk,
	    kn10kmdk
           FROM _00_grundkort.adresser
            WHERE komnr::int in(101,147,151,153,155,157,159,161,163,165,167,169,173,175,183,185,187,190,201,210,217,219,223,230,240,250,260,270)) adr
     LEFT JOIN _00_grundkort.lp_erhvervsomraader_pdk erh ON st_within(adr.the_geom, erh.the_geom)
     LEFT JOIN ( SELECT
            lavbebyg.the_geom,
            lavbebyg.feat_type
           FROM _00_grundkort.lavbebyg
        UNION
         SELECT
            hojbebyg.the_geom,
            hojbebyg.feat_type
           FROM _00_grundkort.hojbebyg
        UNION
         SELECT 
            bykerne.the_geom,
            bykerne.feat_type
           FROM _00_grundkort.bykerne
        UNION
         SELECT 
            industri.the_geom,
            industri.feat_type
           FROM _00_grundkort.industri) bebyg ON st_within(adr.the_geom, bebyg.the_geom);
