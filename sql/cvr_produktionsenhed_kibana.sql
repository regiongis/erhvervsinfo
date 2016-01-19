CREATE MATERIALIZED VIEW kibana.cvr_prodenhed_hrks AS
SELECT cvr.*, plan.plannr as "LP plannummer", plan.plannavn as "LP plannavn", plan.anvendelsespecifik as "LP anvendelsespecifik", plan.anvendelsegenerel as "LP generel anvendelse", plan.zonestatus as "LP zonestatus", jord.temanavn as "Forurenet jord", doklink as "Lokalplan pdf", bebyg.feat_type as bebyggelsestype
FROM cvr.cvr_prod_enh_hrks cvr
LEFT JOIN --Lokalplaner
	(SELECT plannr, plannavn, doklink, anvendelsespecifik, anvendelsegenerel, zonestatus, the_geom
	   FROM _00_grundkort.lokalplaner_v) plan
ON st_within(cvr.the_geom, plan.the_geom)
LEFT JOIN --Forurenet jord
	(SELECT temanavn, the_geom
	   FROM _00_grundkort.dkjord_v1
	UNION
	 SELECT temanavn, the_geom
	   FROM _00_grundkort.dkjord_v2) jord
ON st_within(cvr.the_geom, jord.the_geom)
LEFT JOIN --Bebyggelsestype fra FOT
	(SELECT lavbebyg.the_geom,
	    lavbebyg.feat_type
	   FROM _00_grundkort.lavbebyg
	UNION
	 SELECT hojbebyg.the_geom,
	    hojbebyg.feat_type
	   FROM _00_grundkort.hojbebyg
	UNION
	 SELECT bykerne.the_geom,
	    bykerne.feat_type
	   FROM _00_grundkort.bykerne
	UNION
	 SELECT industri.the_geom,
	    industri.feat_type
	   FROM _00_grundkort.industri) bebyg
ON st_within(cvr.the_geom, bebyg.the_geom)
--LIMIT 1000
