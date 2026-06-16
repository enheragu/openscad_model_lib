#!/usr/bin/env python3

#Generates BOM in CSV format to be used in https://www.cutlistoptimizer.com/


import os
import sys
import subprocess
import re
import csv

script_path = os.path.abspath(__file__)
script_dir = os.path.dirname(script_path)
scad_file = f'{script_dir}/kitchen_furniture.scad'
csv_file = 'bom_boards.csv'

if not os.path.exists(scad_file):
    sys.exit(f'ERROR: file {scad_file} was not found!')


print("Generating BOM...")

scad_log = subprocess.check_output(
        ['openscad', '-o', 'preview.png', '--viewall', '--autocenter', '--imgsize=1920,1080', scad_file],
        stderr=subprocess.STDOUT
    ).decode("utf-8")
pos = 0

#print(scad_log)
print("Calculating...")

bom_list = {}

bom_mark = "BOM_ITEM: "

regex = r'\[x(\d+)\]\s+\[(\d+(\.\d+)?,\s*\d+(\.\d+)?,\s*\d+(\.\d+)?)\]'
regex = r'([a-zA-Z\s\/]+)\s+\[x(\d+)\]\s+\[(\d+(\.\d+)?,\s*\d+(\.\d+)?,\s*\d+(\.\d+)?)\]'

matches = re.findall(regex, scad_log)

rows = ['Length,Width,Qty,Label,Enabled']
for match in matches:
    # rows.append(f"{match[1].replace(', 1.6','')}, {match[0]},true")
    dimensions = match[2].replace(', 1.6','').replace('1.6, ','')
    part_name = (match[0].replace('\t','')).replace(' ','')
    rows.append(f"{dimensions}, {match[1]}, {part_name}, true")



print('BOM in CSV format:\n')
print('\t'+'\n\t'.join(rows))
with open(csv_file, mode='w', newline='') as archivo_csv:
    writer = csv.writer(archivo_csv)
    for row in rows:
        writer.writerow([row])


print('BOM in cut format:\n')

for row in rows[1:]:
    row_list = row.split(',')
    num_items = row_list[2]
    length1, length2 = float(row_list[0]), float(row_list[1])
    print(f'{num_items} --- {max(length1, length2)} x {min(length1, length2)}')