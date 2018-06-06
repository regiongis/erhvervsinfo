
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


