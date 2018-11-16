
-- # LAVER MATERIALIZED VIEW

CREATE MATERIALIZED VIEW cvr.cvr_fad_seneste AS
  SELECT * 
  FROM cvr.cvr_fad 
  WHERE indlaest_dato = (SELECT MAX(cvr.cvr_fad.indlaest_dato) FROM cvr.cvr_fad);


-- # OPDATERER MATERIALIZED VIEW

REFRESH MATERIALIZED VIEW cvr.cvr_fad_seneste;
