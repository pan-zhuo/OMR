#!/usr/bin/env python
# coding: utf-8

# In[1]:


import csv
import xml.etree.ElementTree as ET
from pathlib import Path


# In[2]:


def get_desc(fn, dn):
    desc = "Not even in CSV"
    
    d = csv_p / dn
    
    for f in d.glob('*.csv'):
        if f.name.split("_")[0] == fn.split(".")[0]:
            with open(f, newline="") as csvfile:
                reader = csv.reader(csvfile, delimiter=",")
                for row in reader:
                    if row[0] == "meta" and row[1] == "note" and row[2] != "":
                        desc = row[2]
    
    return desc


# In[3]:


def par_xml(fp, op, dn):
    
    tree = ET.parse(fp, parser=ET.XMLParser(target=ET.TreeBuilder(insert_comments=True)))
    root = tree.getroot()
    
    ET.register_namespace("dct", "http://purl.org/dc/terms/")
    ET.register_namespace("skos", "http://www.w3.org/2004/02/skos/core#")

    ns = {"dct":"http://purl.org/dc/terms/", "skos":"http://www.w3.org/2004/02/skos/core#"}
    
    for scheme in root.findall('skos:ConceptScheme',ns):
        scheme.find('dct:description',ns).text = get_desc(fp.name, dn)
    
    tree.write(op, encoding="UTF-8", xml_declaration=True)


# In[4]:


p = Path(".")
csv_p = p / "csv"
out_p = p / "output"
for d in out_p.iterdir():
    for f in d.glob('*.xml'):
        wd_p = p / "output_wd" / d.name / f.name
        par_xml(f, wd_p, d.name)

