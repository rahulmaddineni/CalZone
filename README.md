# CalZone


## About the app:
> The application consists of three main uses:
### Restaurants:
* It provides the nearby restaurants to the user based on his/her location.
* Each restaurant will provide the user with:
1. Name of the restaurant
2. Map view of the restaurant
3. Distance to the restaurant
4. Address of the restaurant
5. Check-in to the restaurant

### Timeline:
* It provides the user past check-in’s 
*	Each check-in provides the user with:
1. Name of the restaurant
2. Time of the check-in
3. Date of the check-in
4. Map view of the restaurant
5. Image for check-in

### Split Bill:
* It provides the user with:
1. People who owe the user
2. People who the user owes to
*	User can:
1. Pick a contact
2. Enter the amount
*	Choose an option
1.	User owes to person picked
2. 	Person picked owes to the user

## Targeted Audience:
The application comes under the Food & Drink category in the App Store.
The audience for the application might be:
-	People who love to explore new restaurants
-	People who wants to find a restaurant nearby to eat 
-	People who wants to save their exploration with friends
-	People who wants to split the bill among friends 

## Technical Details:
### Login & Register
The application consists of a login and register views for the user to use the functionalities of the application.
The login view is used to log in to the application if the user is already registered so it contains:
-	Text field for Email Address
-	Text field for Password
-	Button for Log In
The register view is used by a new user who wants to access the application features. So, it contains:
-	Text field for First Name
-	Text field for Last Name
-	Text field for Gender
-	Text field for Email address
-	Text field for password
-	Text field for re-enter password
-	Button to register

The user authentication with email and password is provided by the Firebase. The developer needs to register an application in the firebase console. The firebase provides the functions to register a user and log in a user with email and password.
```javascript
FIRAuth.auth()?.signInWithEmail(email, password) { }    // sign-in the user 
FIRAuth.auth()?.createUserWithEmail(email, password) { } // register the user 
```
The other details are stored in the firebase database. The extra verification is provided for user with re-enter the password, as the user might enter the password wrong in his first attempt.

### Nearby Restaurants
The nearby restaurant view provides the user with list of restaurants nearby the user based on his/her location.
The restaurants view consists of:
A Table view with custom cell is created. The custom cell helps in creating custom design for the table view cell.
The custom cell consists of:
-	Name label
-	Distance label
These represent the name of the restaurant and the distance from user location to the restaurants location.
The table view custom cell consists of a detail view which presents the details of the restaurant:
-	Map View
-	Name label 
-	Distance label
-	Address label
Which displays the address of the location on the map and the name, distance from user’s location, address of the restaurant in their respective labels.
The map displays:
-	Annotation of the address 
-	Current location of the user

##### To implement this view:
- The data is provided by the Foursquare API. The developer needs to register the application in the Foursquare which provides the Client ID and Client Secret to access the Foursquare data through the application.
- The idea is to update the table view with new restaurants for every 500 meters with a distance span of 3000 meters. So, to get the user’s location we use the CLLocation provided by the iOS. The Foursquare API call is made after every 500 meters to update the venues.
- A session needs to be created with the Client ID and the Client Secret provided by the Foursquare. The Foursquare API provides the venue results through an asynchronous call in the session.
```javascript
searchTask = session.venues.search(parameters){   (result) 
Then the result is captured in the response from the API.                
response = result.response
```
The data obtained from Foursquare is:
-	Venue Id
-	Venue name
-	Venue address
-	Venue location 
- Latitude
- Longitude
- Distance from the user’s location

###### Used Realm to store the venues. As Realm is:
1. The first database built from scratch for mobile devices. 
2. It’s fast and simple. 
3. It can handle large load of data unlike NSUserDefaults which is really simple to store small amounts of data, but it does not support querying.
4. It does not need an encoder and decoder to store the objects

* The Realm Object will store the venue data which will be queried to get the distance of the restaurants in a sorted order.
* The Map Kit is used to provide the map view for the detail view of the restaurant by using the latitude and the longitude values provided by the API.
* A custom annotation is created which displays the address of the location on the map.

#### Profile
The profile view is provided with:
-	Image 
-	First Name Label
-	Last Name Label
-	Gender Label
-	Logout button

* The image reflects the gender of the user. If the user is male an image of male animated person is displayed, else if the user is female an image of female animated person is displayed.
* The first name, last name and gender label reflect the information provided by the user at the time of registration. So, they are acquired from firebase database.
* The logout button provides user to logout of the application. The logout function is proided by Firebase.
```javascript
FIRAuth.auth().signOut()  // log out the user
```

#### TimeLine
The TimeLine tab displays all the places user had checked-in with date & time linked to them. The check-ins are displayed as a Table view with each check-in as a TimeLine cell. All the data about a check-in is created, stored as TimeLine items in the TimeLine Item Store. 
* TimeLine cell consists of:
-	Place label
-	Time label

These represent the name of the restaurant and the timestamp when the check-in is made.

* Each TimeLine Item has the following fields:
-	Place
-	timeStamp
-	latitude
-	longitude
-	address

* All the Items in the TimeLine Item Store of the TimeLine has a create Item function
* The createItem function takes all the 5 parameters of TimeLine and return a TimeLine Item, which is added into the TimeLine Item Store
* When user selects any check-in from the TimeLine View Controller, it sends the item details through a segue to Map Detail View Controller.
* The Detail View Controller contains a Map Kit which displays a map snippet using the latitude, longitude of the restaurant. User can also add / change an image for a check-in using the browse photo button.
* When the browseImage button is checked, a imagePicker view pops up asking to choose either Camera or Photo Library. Once an image is selected, delegate is called. The delegate then uploads the image to firebase’s storage folder and URL is stored in item’s ImageURL child for the user. After this is done, when the view is reloaded, dispatcher is called to print the image in ImageView of the mapDetailViewController.

#### Split Bill
The Split Bill tab of the application allows users to split bill with people in contacts. The Split bill controller has two sections in which contacts are categorized depending on the total balances.
-	You owe (< $0). Total balance will be in negative, indicating that the user need to pay the contact the balance
-	You are owed (> $0). Total balance will be in positive, indicating contact needs to pay the user the balance shown
* A ItemStore is created for all the Items in Split Bill module. The SplitBill Item Store has create item function which takes name, money and returns an Item. The remove Item in the SplitBill Item Store takes the item object and deletes it and reloads the table view. 

Each Item in the Item Store has 2 data members
-	name: name of the contact
-	money: total balance
* When an Item is created, initializer is called by giving name, money as parameters. Then, the item is added to the ItemStore. 
* When the tableView is being initialized, data from Firebase is downloaded in a dictionary and createItem is called on every item. After the item is created, Items are categorized into two sections depending on the money. 

Each item on the table ViewController of SplitBill tab has 2 labels:
-	name Label
-	money Label

Adding a new bill:
- Clicking on the Add button on the View Controller
-	Contact ViewController is called and asks for permission, if first time, to view contacts on the phone. Contacts are loaded into a CNContact array
- When a contact is selected, name is sent to a detail view controller through a Segue. 
- In the detail view controller, user will be asked to enter a dollar amount and given 4 options in form of a UIPicker to share the bill
1. You owe them full – User needs to pay the contact the entire dollar amount
2. They owe you in full – Contact needs to pay the entire dollar amount to User
3. Split the bill in half & paid by you – User gets half of the dollar amount from the contact
4. Split the bill in half & paid by them – User needs to pay half of the dollar amount to the contact
And when done button is clicked, unwind to segue is called and redirected to main View Controller of Split Bill

* Selecting a contact on the SplitBill View Controller
- The same earlier detail view controller is called and asked the user to enter money and select one of the 4 split bill options.
- When done button is selects, it is again unwinded to the main view controller.

### Model View Architecture
![alt text](https://github.com/rahulmaddineni/CalZone/blob/master/ScreenShots/5.PNG "Architecture")

### Screen Shots
![alt text](https://github.com/rahulmaddineni/CalZone/blob/master/ScreenShots/1.PNG "Login & Register")
![alt text](https://github.com/rahulmaddineni/CalZone/blob/master/ScreenShots/2.PNG "Detailed Info & Profile")
![alt text](https://github.com/rahulmaddineni/CalZone/blob/master/ScreenShots/3.PNG "Timeline")
![alt text](https://github.com/rahulmaddineni/CalZone/blob/master/ScreenShots/4.PNG "SpliBill")


> Future Work
-	Provide a calendar view for check-ins with a month view and day view to group a set of check-ins
-	Provide Menu for the restaurant along with some calorie information
-	Provide an option to search for restaurants
-	Provide restaurant categories: Italian, Indian, Chinese, French, …
-	Provide the results by age based restrictions such as restricting the users under 21 to restaurant data but not bars
-	Provide option to input user ratings
-	Provide option to add friends so:
- Can share in app details like split bill (if present sent via app else sent via text)
- Can allow friends to view the check-ins by the user
- Can tag friends in a check-in
-	Provide the user option to update password
-	Provide user the option to upload profile image

### References
-	Firebase (www.firebase.com)
-	Foursquare (www.developer.foursqaure.com)
-	Realm (ww.relam.io)

