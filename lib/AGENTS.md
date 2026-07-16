# The Master File
The AGENTS markdown file is responsible for detailing the overall architecture of the
Flutter app, concerning the mobile app's development of the library directory which
includes these following files along with some overview details about them.

## Library
The lib directory contains screens, widgets, utilities, models, data, and services.

## Data
The data folder hosts the database helper module. The database helper module contains
a class which creates a static instance of the database, method members which run SQL
queries to create the database with all relevant tables, and other method members which
interact with a given table's resource, whether creating, reading, updating, or deleting.
At the moment, not every resource has dedicated CRUD support, most of which will be developed
as the project continues.

Please Note: The current architecture pattern is not to call any method member directly from
the database from a screen. There is a layer between the UI and the data which covers validation
and response to and from the UI and data. For example, if a query in the database results in a
failure, the layer in-between the data and UI layer will respond to the UI layer with that failure
to communicate to the user what went wrong where.

