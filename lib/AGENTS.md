# The Master File
@./AGENTS.md 

The AGENTS markdown file is responsible for detailing the overall architecture of the
Flutter app, concerning the mobile app's development of the library directory which
includes these following files along with some overview details about them.

## Library
@./lib

The lib directory contains screens, widgets, utilities, models, data, and services.

## Data
@./lib/data

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

## Models
@./lib/models

The model files, @./lib/models/*.dart describe how SQL queries which returns a list of
database records should be mapped according to the data types used in the project. These models
are generally used in the service files of the same name where the database records need to be
mapped to real data types used in the project. To avoid confusion about what data types are being
used in the development of screens or widgets.

## Screens
@./lib/screens

The screens directory contains the files which describe the UI to be rendered in the mobile app.
These are the core of the project, are the source from which users make requests for data and their
various operations. Each screen serves a unique purpose, though they may be created with reusable
components, track transient state before submission to the database, or pull from the database to 
display current state of records in the UI to the user.

## Services
@./lib/services

The services directory is the layer between the UI layer and the data layer as mentioned in data
section. These files contain validation logic, handle responses to and from either layer, mapping
database records to dart-typed models. Much of the additional logic not found in the Screens
directory will be found in here. Overall the flow generally follows this path:

    Data -> Services -> Screens

Screens depends on methods in services, services depends on methods in data.


