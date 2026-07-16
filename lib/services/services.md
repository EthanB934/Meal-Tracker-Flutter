# Services
The services directory is the layer between the UI layer and the data layer as mentioned in data
section. These files contain validation logic, handle responses to and from either layer, mapping
database records to dart-typed models. Much of the additional logic not found in the Screens
directory will be found in here. Overall the flow generally follows this path:

    Data -> Services -> Screens
Screens depends on methods in services, services depends on methods in data.
