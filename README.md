# CochleariOS
An app for a social photography startup. It maintains a list of scenic photo locations around Sydney. The users will see all these default
locations, plus be able to add their own locations, as well as add notes about each location.

# Application Design & Architecture
The native iOS application is written in swift using Xcode.Google Firebase cloustore has been used as the backend-as-a-service provider. Google Maps API for iOS has been used to display the map view.

# Explicit Requirements
- Provide a map screen (using any map SDK of your choosing)
- Allow custom locations to be added from the map screen
- The user should be able to provide names for these locations
- Show pins for both default and custom locations on the map
- Provide a screen listing all locations, sorted by distance
- When locations are selected on either the map or list screen, show a detail screen
- In the detail screen, allow the user to enter notes about the location
- All information entered by the user must be persisted between app launches

# Application Flow

<img width="250" alt="architecture" src="https://user-images.githubusercontent.com/19331629/70877138-65573100-2010-11ea-98db-c0cc4e9030d7.png"> <img width="250" alt="architecture" src="https://user-images.githubusercontent.com/19331629/70877205-ab13f980-2010-11ea-8cd1-aa7b8b892086.png"> <img width="250" alt="architecture" src="https://user-images.githubusercontent.com/19331629/70877216-b9faac00-2010-11ea-8917-bab87c5a2997.png"> <img width="250" alt="architecture" src="https://user-images.githubusercontent.com/19331629/70877250-df87b580-2010-11ea-8972-8af69d495be8.png"> <img width="250" alt="architecture" src="https://user-images.githubusercontent.com/19331629/70877282-f62e0c80-2010-11ea-8669-990c6fbb5ad4.png"> <img width="250" alt="architecture" src="https://user-images.githubusercontent.com/19331629/70877302-0cd46380-2011-11ea-8877-bc1380c28d21.png"> <img width="250" alt="architecture" src="https://user-images.githubusercontent.com/19331629/70877331-207fca00-2011-11ea-9869-99e4a10282c1.png"> <img width="250" alt="architecture" src="https://user-images.githubusercontent.com/19331629/70877351-368d8a80-2011-11ea-8a48-7928bc587d5b.png"> <img width="250" alt="architecture" src="https://user-images.githubusercontent.com/19331629/70877377-50c76880-2011-11ea-93b2-6e5b086c4fda.png">

# Testing Process
- Run using an emulator or usb device after opening the project in Xcode

### Application start
On application start, it will display a map view with 2 buttons. The maps screen open asking for permission to access your current location. The user can see landmarks posted by other users, and search them. However, they will not be able to find their own location, but will be able to create any new landmarks on the map.A blue dot indicating the current location is displayed on location permission access.

### Adding a landmark with a title
When the application is started and location permission is approved, then the user is automatically pointed to its current location. The user can create landmark at their current location and any other location on the map. The primary way to create a new landmark is to click any location on the map which will display a dialog to insert a title on that location.After entering a title and clicking ok a landmark with a title is created for that user which can be looked up by clicking on the marker. On clicking cancel, the marker is not added to the map. The marker is represented by a red location icon.

### Adding details to a landmark
After a landmark is crated, the user can add specific notes by clicking on the existing landmark which displays a detail screen to add a note. On clicking save some details about the landmark gets saved in the database. On clicking cancel, no details are created.

### List button
The list button displays a list view of all the locations from the JSON Url and the new locations that were sorted by distance from the current location. On clicking a list item it navigates to the detail screen displaying the details of the location with the feature to add details to it.

# Technology Stack
- Xcode using swift
- Firebase Cloudstore
- Google Maps SDK and API

# Time Estimation
6-8 hours

# Support
Stack Overflow


