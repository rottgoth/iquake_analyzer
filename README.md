# iQuake Analyzer

Using data from the US Geolgical survey, create a tool that does the following:

1. List all earthquakes in California in the past month, sorted by decreasing magnitude
2. List all earthquakes in the top 3 US states (by number of quakes), sorted by state then by decreasing magnitude

Data feed: [https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson](https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson)

### Example output:

```
2017-07-13T22:09:53+00:00 | 41km SW of Ferndale, California | Magnitude: 2.76
2017-07-13T22:54:30+00:00 | 3km SE of Atascadero, California  | Magnitude: 2.04
2017-07-13T22:45:28+00:00 | 37km SE of Bridgeport, California | Magnitude: 1.7
2017-07-13T22:31:04+00:00 | 11km E of Mammoth Lakes, California | Magnitude: 1.31
2017-07-13T20:43:37+00:00 | 3km NW of Greenville, California  | Magnitude: 1
2017-07-13T22:37:52+00:00 | 12km E of Mammoth Lakes, California | Magnitude: 0.95
2017-07-13T22:32:48+00:00 | 15km SE of Mammoth Lakes, California  | Magnitude: 0.92
2017-07-13T22:49:58+00:00 | 8km ENE of Mammoth Lakes, California  | Magnitude: 0.92
```

## Installation

TBD

## View results using Rake Task

```
# List all earthquakes in California in the past month, sorted by decreasing magnitude
rake i_quake:list_california_earthquakes

# List all earthquakes in the top 3 US states (by number of quakes), sorted by state then by decreasing magnitude
rake i_quake:list_top_us_cities_earthquakes
```