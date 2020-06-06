import json
result = {}
tmp = {}
with open('country-and-continent-codes-list.json', 'r') as file:
    data = file.read()
countries = json.loads(data) 
with open('gdp.json', 'r') as file:
    data = file.read()
gdp = json.loads(data) 
with open('cpi.json', 'r') as file:
    data = file.read()
cpi = json.loads(data) 
with open('population.json', 'r') as file:
    data = file.read()
population = json.loads(data) 

for c in countries:
    if not c["Three_Letter_Country_Code"] is None:
        tmp[c["Three_Letter_Country_Code"]] = { "continentName" : c["Continent_Name"], "countryName" : c["Country_Name"], "countryCode" : c["Three_Letter_Country_Code"]}
    
for c in population:
    if not c["Value"] is None and c["Country Code"] in tmp and c["Year"] == 2014:
        tmp[c["Country Code"]]["population"] = c["Value"]
for c in gdp:
    if not c["Value"] is None and c["Country Code"] in tmp and c["Year"] == 2014:
        tmp[c["Country Code"]]["gdp"] = c["Value"]
for c in cpi:
    if not c["CPI"] is None and c["Country Code"] in tmp and c["Year"] == 2014:
        tmp[c["Country Code"]]["cpi"] = c["CPI"]
for key in tmp:
    c = tmp[key]
    if c.get("population") is None or c.get("cpi") is None or c.get("gdp") is None:
        continue
    if not c["continentName"] in result:
        result[c["continentName"]] = [{"countryName" : c["countryName"], "countryCode" : c["countryCode"], "population": c["population"], "gdp": c["gdp"], "cpi": c["cpi"]}]
    else:
        result[c["continentName"]].append({"countryName" : c["countryName"], "countryCode" : c["countryCode"], "population": c["population"], "gdp": c["gdp"], "cpi": c["cpi"]})
jsonstr = json.dumps(result)
print(jsonstr)
with open("result.json", "w") as file:
    file.write(jsonstr)
