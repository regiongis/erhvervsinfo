# -*- coding: utf-8 -*-

# Dette script forbinder til en postgres database, og henter en liste
# med pNumre. For hvert pNummer slås op i virks.dk's Elastic Search
# database, og historik på forskellige områder hentes og gemmes i en
# json fil kaldet [pNummer].json

# Scriptet er ikke beregnet til store datamængder, dels fordi der ikke
# er implementeret nogen fejlhåndtering, og dels resulterer scriptet
# i en stor mængde json filer når det køres.

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

import json
import sys
import traceback
import psycopg2
from os import path
from datetime import datetime
from elasticsearch import Elasticsearch
from elasticsearch_dsl import Search


# CVR Elastic Search credentials
ES_username = 'Tabula_CVR_I_SKYEN'
ES_password = '63ae874d-eb76-4772-a660-05246917edcf'
ES_host = 'distribution.virk.dk'
ES_port = 80
ES_index = 'cvr-permanent'

# Ballerup Kommune PostgreSQL credentials
PG_username = 'svejagd'
PG_password = '8MzLuOKMnpgZHnmc1IxS'
PG_host = 'drayton.mapcentia.com'
PG_port = 5432
PG_database = 'ballerup'

# Schema, table and column name for 'pNummer'
PG_schema = 'cvr'
PG_table = 'cvr_prod_enhed_geo'
PG_column = 'pnr'

# Connect to database
try:
    conn = psycopg2.connect(user=PG_username, password=PG_password, host=PG_host, port=PG_port, dbname=PG_database)
except:
    print "Database connection error. Check credentials and connection."
cur = conn.cursor()

startTime = datetime.now()

# Get list of pNummer while checking for the correct data type
sql = """SELECT {} FROM {};""".format(PG_column, PG_schema+'.'+PG_table)
cur.execute(sql)
rows = cur.fetchall()
assert(len(rows) >= 1)
assert(isinstance(rows[0], tuple))
pnr_list = [element[0] for element in rows]
assert(isinstance(pnr_list[0], long))
pnr_list = [int(pnr) for pnr in pnr_list]

# Close database connection
cur.close()
conn.close()

# Prepare Elastic Search client
url = 'http://{}:{}@{}:{}'.format(ES_username, ES_password, ES_host, ES_port)
client = Elasticsearch(hosts=url)

exc_count = 0
pnr_list_length = len(pnr_list)
# Loop over the list of pNumre and write out json files with interesting data
for num, pnr in enumerate(pnr_list):
    num += 1
    if num%10000 == 1:
        print "Doing {} of {}".format(num, pnr_list_length)
    try:
        out_dict = dict()
        search_dict = {"query":
                           {"term":
                                {"produktionsenhed.VrproduktionsEnhed.pNummer": pnr}
                            }
                       }
        s = Search(using=client, index=ES_index)
        s.update_from_dict(search_dict)
        response = s.execute()
        if response.hits.total == 0:
            continue
        assert(response.hits.total == 1)
        h = response.hits[0]
        assert(h.meta.doc_type == 'produktionsenhed')
        d = h.to_dict()['VrproduktionsEnhed']

        # History of addresses
        adr = d['beliggenhedsadresse']
        if len(adr) > 1:  # If the p-enhed has moved, there will be more than one address
            out_dict['beliggenhedsadresse'] = adr

        # History of employment
        aar_besk = d['aarsbeskaeftigelse']
        if len(aar_besk) > 0:
            out_dict['aarsbeskaeftigelse'] = aar_besk

        kvart_besk = d['kvartalsbeskaeftigelse']
        if len(kvart_besk) > 0:
            out_dict['kvartalsbeskaeftigelse'] = kvart_besk

        if len(out_dict) >= 1:
            with open(path.join('json', str(pnr)+'.json'), 'wb') as out_file:
                json.dump(out_dict, out_file, sort_keys=False, indent=4, separators=(',', ': '))
    except KeyboardInterrupt:
        sys.exit()
    except:
        exc_count += 1
        print '******EXCEPTION {}********'.format(exc_count)
        traceback.print_exc()
        print '\n\n'

print u"Script took {} seconds.".format((datetime.now()-startTime).total_seconds())
