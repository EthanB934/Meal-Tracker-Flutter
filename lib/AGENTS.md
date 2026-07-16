# The Master File
@./AGENTS.md 

The AGENTS Markdown file is responsible for detailing the overall architecture of the
Flutter app, concerning the mobile app's development of the library directory which
includes these following files along with some overview details about them.

## Library
@./lib

Library Structure (lib/): The core functionality is divided into several subdirectories:

Data (lib/data/data.md): This layer handles database operations, including creating 
tables and performing CRUD (Create, Read, Update, Delete) operations. It also enforces
a separation where the UI layer does not call database methods directly, introducing an
intermediate layer for validation and response handling.


Models (lib/models/models.md): This directory contains the data models (Dart classes)
used to map SQL query results into real data types within the application.


Screens (lib/screens/screens.md): This layer contains all the UI elements that are 
rendered in the mobile app, handling user requests and displaying data fetched from
the other layers.


Services (lib/services/services.md): This acts as an intermediary layer between the UI 
(Screens) and the Data layer. It contains the business logic, validation, and mapping 
responsibilities (e.g., mapping database records to Dart models).


Utilities (lib/utils/utilities.md): This folder stores general helper functions, 
performing off-hand calculations used in screen rendering, such as fetching the current
time for greetings.


Widgets (lib/widgets/widgets.md): This layer contains customized or extended UI components
that are used to enhance the appearance and behavior of the application 
(e.g., customizing ExpansionTile widgets).

In essence, the flow is strictly defined: Screens depends on Services, Services depends 
on Data. The architecture successfully separates concerns related to data management, 
business logic, presentation, and UI components.

## Data
@./lib/data/data.md

## Models
@./lib/models/models.md

## Screens
@./lib/screens/screens.md

## Services
@./lib/services/services.md

## Utilities
@./lib/utils/utilities.md

## Widgets
@./lib/widgets/widgets.md