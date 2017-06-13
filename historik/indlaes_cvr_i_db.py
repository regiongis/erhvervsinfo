# -*- coding: utf-8 -*-

# Dette script forbinder til en postgres database, og henter en liste
# med pNumre. For hvert pNummer slås op i virks.dk's Elastic Search
# database, og historik på forskellige områder hentes og gemmes i en
# tabel i databasen

# Copyright (C) 2017 Tabula I/S

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


import sys
import logging
import traceback
import psycopg2
from time import sleep
from datetime import datetime
import elasticsearch
from elasticsearch_dsl import Search

def change_interval(s):
    if s == None:
        return None
    elif s == 'ANTAL_0_0':
        return '0'
    elif s == 'ANTAL_1_1':
        return '1'
    elif s == 'ANTAL_2_4':
        return '2 - 4'
    elif s == 'ANTAL_5_9':
        return '5 - 9'
    elif s == 'ANTAL_10_19':
        return '10 - 19'
    elif s == 'ANTAL_20_49':
        return '20 - 49'
    elif s == 'ANTAL_50_99':
        return '50 - 99'
    elif s == 'ANTAL_100_199':
        return '100 - 199'
    elif s == 'ANTAL_200_499':
        return '200 - 499'
    elif s == 'ANTAL_500_999':
        return '500 - 999'
    elif s == 'ANTAL_1000_999999':
        return '1000+'

startTime = datetime.now()
max_date = datetime.strptime("2017-01-24", '%Y-%m-%d').date()

# CVR Elastic Search credentials
ES_username = 'username' # replace this
ES_password = 'password' # replace this
ES_host = 'distribution.virk.dk'
ES_port = 80
ES_index = 'cvr-permanent'

# Ballerup Kommune PostgreSQL credentials
PG_username = 'username' # replace this
PG_password = 'password' # replace this
PG_host = 'drayton.mapcentia.com'
PG_port = 5432
PG_database = 'ballerup'

# Schema, table and column name for 'pNummer'
PG_schema = 'cvr'
PG_table = PG_schema+'.'+'cvr_prod_enhed_geo_stam'
PG_column = 'pnr'

PG_hist_adresser = PG_schema+'.'+'cvr_prod_enhed_geo_hist_adresser'
PG_hist_ansatte_aar = PG_schema+'.'+'cvr_prod_enhed_geo_hist_ansatte_aar'
PG_hist_ansatte_kvart = PG_schema+'.'+'cvr_prod_enhed_geo_hist_ansatte_kvartal'
PG_hist_ansatte_maaned = PG_schema+'.'+'cvr_prod_enhed_geo_hist_ansatte_maaned'
PG_hist_hovedbranche = PG_schema+'.'+'cvr_prod_enhed_geo_hist_hovedbranche'

def extract_date_from_address(address_dict):
    return address_dict['periode']['gyldigFra']

# Setup of logging
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
fh = logging.FileHandler('data_getter.log')
fh.setLevel(logging.INFO)
ch = logging.StreamHandler()
ch.setLevel(logging.WARNING)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
fh.setFormatter(formatter)
ch.setFormatter(formatter)
logger.addHandler(fh)
logger.addHandler(ch)

# Connect to database
conn = None
def connect_to_db():
    global conn
    try:
        logger.info("Connecting to database...")
        conn = psycopg2.connect(user=PG_username, password=PG_password, host=PG_host, port=PG_port, dbname=PG_database)
    except psycopg2.OperationalError as e:
        logger.info("Could not connect to database")
        logger.exception(e)
        raise e
connect_to_db()

logger.info("Connection established")
cur = conn.cursor()

# Get list of pNummer
logger.info("Retrieving pNumbers...")
# select all pnummer that has no enty with kilde='virk.dk' in one of the hist tables
sql = """SELECT a.{} FROM {} a
         LEFT JOIN (SELECT pnr FROM cvr.cvr_prod_enhed_geo_hist_adresser WHERE kilde = 'virk.dk') b ON a.pnr = b.pnr
         LEFT JOIN (SELECT pnr FROM cvr.cvr_prod_enhed_geo_hist_ansatte_aar WHERE kilde = 'virk.dk') c ON a.pnr = c.pnr
         LEFT JOIN (SELECT pnr FROM cvr.cvr_prod_enhed_geo_hist_ansatte_kvartal WHERE kilde = 'virk.dk') d ON a.pnr = d.pnr
         WHERE b.pnr IS NULL AND c.pnr IS NULL AND d.pnr IS NULL;""".format(PG_column, PG_table)
cur.execute(sql)
rows = cur.fetchall()
assert(len(rows) >= 1)
assert(isinstance(rows[0], tuple))
pnr_list = [element[0] for element in rows]
assert(isinstance(pnr_list[0], long))
pnr_list = [int(pnr) for pnr in pnr_list]
pnr_list_length = len(pnr_list)
logger.info("Retrieved {} pNumbers".format(pnr_list_length))

# Prepare Elastic Search client
url = 'http://{}:{}@{}:{}'.format(ES_username, ES_password, ES_host, ES_port)
client = elasticsearch.Elasticsearch(hosts=url)
reconnect_attempted = False
uncatched_exc_count = 0
# Loop over the list of pNumre and write out json files with interesting data
for num, pnr in enumerate(pnr_list):
    num += 1
    while True:
        try:
            logger.info("Doing request {} of {}".format(num, pnr_list_length))
            out_dict = dict()
            search_dict = {"query":
                               {"term":
                                    {"produktionsenhed.VrproduktionsEnhed.pNummer": pnr}
                                }
                           }
            s = Search(using=client, index=ES_index)
            s.update_from_dict(search_dict)
            response = s.execute()
            if response.success() and reconnect_attempted:
                logger.warning('Connection reestablished!')
                reconnect_attempted = False
            if response.hits.total == 0:
                logger.warning("No hits for pNummer {}".format(pnr))
                break
            assert(response.hits.total == 1)
            h = response.hits[0]
            assert(h.meta.doc_type == 'produktionsenhed')
            d = h.to_dict()['VrproduktionsEnhed']

            # History of addresses
            adr = d['beliggenhedsadresse']
            if len(adr) > 1:  # If the p-enhed has moved, there will be more than one address
                latest_address = None # Used for removing duplicate addresses caused by kommunalreformen
                for address in sorted(adr, key=extract_date_from_address, reverse=True):
                    street_address = unicode(address['vejnavn'])+' '+unicode(address['husnummerFra'])+' '+unicode(address['postnummer'])
                    # Don't write address if it is a duplicate caused by the kommunal reform
                    if street_address == latest_address and address['kommune']['periode']['gyldigTil'] == "2006-12-31":
                        continue
                    latest_address = street_address
                    # Don't write address if it is the newest
                    if address['periode']['gyldigTil'] is None:
                        continue
                    if datetime.strptime(address['periode']['gyldigTil'], '%Y-%m-%d').date() > max_date:
                        continue
                    beliggenhedsadresse_gyldigfra = address['periode']['gyldigFra']
                    beliggenhedsadresse_vejnavn = address['vejnavn']
                    beliggenhedsadresse_vejkode = address['vejkode']
                    belig_adresse_husnummerfra = address['husnummerFra']
                    belig_adresse_husnummertil = address['husnummerTil']
                    beliggenhedsadresse_bogstavfra = address['bogstavFra']
                    beliggenhedsadresse_bogstavtil = address['bogstavTil']
                    beliggenhedsadresse_etage = address['etage']
                    beliggenhedsadresse_sidedoer = address['sidedoer']
                    beliggenhedsadresse_postnr = address['postnummer']
                    belig_adresse_postdistrikt = address['postdistrikt']
                    beliggenhedsadresse_bynavn = address['bynavn']
                    kommune_kode = address['kommune']['kommuneKode']
                    kommune_tekst = address['kommune']['kommuneNavn']
                    postboks = address['postboks']
                    conavn = address['conavn']
                    fritekst = address['fritekst']
                    encode_list = [e.encode('utf-8') if hasattr(e, 'encode') else e for e in (pnr, beliggenhedsadresse_gyldigfra, beliggenhedsadresse_vejnavn, beliggenhedsadresse_vejkode, belig_adresse_husnummerfra, belig_adresse_husnummertil, beliggenhedsadresse_bogstavfra, beliggenhedsadresse_bogstavtil, beliggenhedsadresse_etage, beliggenhedsadresse_sidedoer, beliggenhedsadresse_postnr, belig_adresse_postdistrikt, beliggenhedsadresse_bynavn, kommune_kode, kommune_tekst, postboks, conavn, fritekst)]
                    SQL = """
                    INSERT INTO {} (kilde, pnr, beliggenhedsadresse_gyldigfra, beliggenhedsadresse_vejnavn, beliggenhedsadresse_vejkode, belig_adresse_husnummerfra, belig_adresse_husnummertil, beliggenhedsadresse_bogstavfra, beliggenhedsadresse_bogstavtil, beliggenhedsadresse_etage, beliggenhedsadresse_sidedoer, beliggenhedsadresse_postnr, belig_adresse_postdistrikt, beliggenhedsadresse_bynavn, kommune_kode, kommune_tekst, beliggenhedsadresse_postboks, beliggenhedsadresse_conavn, belig_adresse_adr_fritekst)
                    VALUES ('virk.dk', %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
                    """.format(PG_hist_adresser)
                    cur.execute(SQL, encode_list)
                    conn.commit()

            aar_besk = d['aarsbeskaeftigelse']
            if len(aar_besk) > 0:
                for employment_data in aar_besk:
                    aar = employment_data["aar"]
                    if int(aar) >= max_date.year: # We are no interested in the newest data, as it is covered by dumps by Per
                        continue
                    interval_aar_ansatte = change_interval(employment_data["intervalKodeAntalAnsatte"])
                    interval_aar_aarsvaerk = change_interval(employment_data["intervalKodeAntalAarsvaerk"])
                    interval_aar_inkl_ejere = change_interval(employment_data["intervalKodeAntalInklusivEjere"])
                    SQL = """
                    INSERT INTO {} (kilde, pnr, aarsbeskaeftigelse_aar, aarsbes_antansatteinterval, aarsbes_antaarsvaerkinterval, aarsbes_antinclejereinterval)
                    VALUES ('virk.dk', %s, %s, %s, %s, %s);
                    """.format(PG_hist_ansatte_aar)
                    cur.execute(SQL, (pnr, aar, interval_aar_ansatte, interval_aar_aarsvaerk, interval_aar_inkl_ejere))
                    conn.commit()

            kvart_besk = d['kvartalsbeskaeftigelse']
            if len(kvart_besk) > 0:
                for employment_data in kvart_besk:
                    aar = employment_data["aar"]
                    if int(aar) >= max_date.year: # We are no interested in the newest data, as it is covered by dumps by Per
                        continue
                    kvartal = employment_data["kvartal"]
                    interval_kvart_aarsvaerk = change_interval(employment_data["intervalKodeAntalAarsvaerk"])
                    interval_kvart_ansatte = change_interval(employment_data["intervalKodeAntalAnsatte"])
                    SQL = """
                    INSERT INTO {} (kilde, pnr, kvartalsbeskaeftigelse_aar, kvartalsbeskaeftigelse_kvartal, kvartalsbeskaeftigelse_antalansatteinterval, kvartalsbeskaeftigelse_antalaarsvaerkinterval)
                    VALUES ('virk.dk', %s, %s, %s, %s, %s);
                    """.format(PG_hist_ansatte_kvart)
                    cur.execute(SQL, (pnr, aar, kvartal, interval_kvart_ansatte, interval_kvart_aarsvaerk))
                    conn.commit()

            hovedbranche = d['hovedbranche']
            if len(hovedbranche) > 1:
                for branche_data in hovedbranche:
                    if branche_data['periode']['gyldigTil'] is None:
                        continue
                    if datetime.strptime(branche_data['periode']['gyldigTil'], '%Y-%m-%d').date() > max_date:
                        continue
                    kode = int(branche_data['branchekode'])
                    tekst = branche_data['branchetekst']
                    gyldig_fra = branche_data['periode']['gyldigFra']

                    SQL = """
                    INSERT INTO {} (kilde, pnr, hovedbranche_gyldigfra, hovedbranche_kode, hovedbranche_tekst)
                    VALUES ('virk.dk', %s, %s, %s, %s)
                    """.format(PG_hist_hovedbranche)
                    cur.execute(SQL, (pnr, gyldig_fra, kode, tekst))
                    conn.commit()

            break
        except KeyboardInterrupt:
            # Close database connection
            cur.close()
            conn.close()
            sys.exit()
        except elasticsearch.exceptions.ConnectionTimeout:
            logger.warning('Timeout in connection. Trying again in 10 seconds...')
            sleep(10)
            reconnect_attempted = True
        except elasticsearch.exceptions.ConnectionError:
            logger.warning('Connection error. Trying again in 10 seconds...')
            sleep(10)
            reconnect_attempted = True
        except psycopg2.InterfaceError:
            logger.warning('Lost database conenction. Trying to reconnect')
            connect_to_db()
        except Exception as e:
            uncatched_exc_count += 1
            print '******EXCEPTION {}********'.format(uncatched_exc_count)
            traceback.print_exc()
            print '\n\n'
            logger.warning('Uncought exception')
            logger.warning(e)
            break

# Close database connection
cur.close()
conn.close()

print u"Script took {} seconds.".format((datetime.now()-startTime).total_seconds())
print u"number of uncaught exceptions: {}".format(uncatched_exc_count)
