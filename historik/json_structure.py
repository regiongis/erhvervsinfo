# -*- coding: utf-8 -*-

# Dette script afsøger en json fil for bestemte keywords (defineret i
# listen 'search_terms'), og udskriver en fil der viser den 'nestede'
# struktur af de steder disse keywords optræder.

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
from os import path

search_terms = ['aar', 'periode']
ignore_terms = ['properties', 'cvr-permanent-prod-20161007', 'mappings']

in_file_path = u'C:\\path\\to\\datamodel.json'
out_file_dir = u'C:\\path\\to\\out\\dir'


def recursive_search(json_dict, search_term, parent_list, outfile):
    for key in json_dict.keys():
        if key == search_term:
            out_line = ' > '.join(parent_list + [key]) + '\r\n'
            outfile.write(out_line)
        elif isinstance(json_dict[key], dict):
            local_list = parent_list[:]  # list must be copied, as we are going to need multiple copies in the recursion
            if key not in ignore_terms:
                local_list.append(key)
            recursive_search(json_dict[key], search_term, local_list, outfile)  # search the sub directory

with open(in_file_path, 'rb') as json_file:
    js = json.load(json_file)

for term in search_terms:
    out_file_name = 'datastruktur_'+term+'.txt'
    out_file_path = path.join(out_file_dir, out_file_name)
    with open(out_file_path, 'wb') as out_file:
        recursive_search(js, term, list(), out_file)
