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

- Clone the repo:
```
git clone git@github.com:rottgoth/iquake_analyzer.git
```

- Run setup script
```
./bin/setup
```

## View results using Rake Task

```
# List all earthquakes in California in the past month, sorted by decreasing magnitude
rake i_quake:list_california_earthquakes

# List all earthquakes in the top 3 US states (by number of quakes), sorted by state then by decreasing magnitude
rake i_quake:list_top_us_cities_earthquakes
```

## View results in browser

Start your local rails server
```
rails s
```

List all earthquakes in California in the past month, sorted by decreasing magnitude

Navigate to: `http://localhost:3000/earthquakes/california_earthquakes`

List all earthquakes in the top 3 US states (by number of quakes), sorted by state then by decreasing magnitude

Navigate to: `http://localhost:3000/earthquakes/top_us_cities_earthquakes`

## Deployed application

I deployed this basic sample application in heroku. You can access it at: [https://iquake-analyzer.herokuapp.com](https://iquake-analyzer.herokuapp.com)

List all earthquakes in California in the past month, sorted by decreasing magnitude

Navigate to: `https://iquake-analyzer.herokuapp.com/earthquakes/top_us_cities_earthquakes`

List all earthquakes in the top 3 US states (by number of quakes), sorted by state then by decreasing magnitude

Navigate to: `https://iquake-analyzer.herokuapp.com/earthquakes/california_earthquakes`

## Further development (TODO)

With more time these are a few of the things I would've liked to implement:

- We are not inserting records for places that don't list a city at the end after a comma. We can improve on that.
- The list of top US cities doesn't validate that the records are ONLY from US cities. I found that somewhere in the list are cities from other countries.
- The USGS list of earthquakes gets updates every 15 minutes. We can create a background job using ActiveJob to fetch and insert new records.
- Once we have data from different months, the service should only query the data for the current month, instead of the whole dataset.
- We can add caching to the UI.
- The current implementation shows the entire list, we could add pagination.
- We can create our own json API.
- We can implement a Single Page Application using React.
- With a React app, we can make the UI more dynamic, like adding filters and sorting controls for different columns.
- We could implement websockets using ActionCable to broadcast to the client application if a new record has been created.

## Development branches

#### Branch: quake_http_client

I started this branch to allow the simplest, most straightforward path to get the problem solved. Its purpose is to get the data and process it so that the desired output can be formatted and printed via a rake task.

#### Branch: using_db

That process takes a considerate amount of time, since it has to load a huge dataset in memory everytime and perform the same processing of data and calculations. In order to make this process simpler and faster, in this branch I've added the database with an earthquakes table with the attributes that I considered most useful.

The main way to generate the output in this branch is via a rake task as well.

#### Branch: html_view / master

In this branch, I added the routes, controller and views so that this application could be deployed and the data accessed anywhere from a web browser.
