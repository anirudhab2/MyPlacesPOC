# MyPlacesPOC

## Description
A simple iPhone application that lets you add places on a map and save the places in a database (Realm) so they will persist across sessions. A good place to start if you want to learn about MapKit or mobile database like Realm.

## Usage
Clone the project, open terminal and run "pod init" from the project directory. This will create a Podfile in the directory. Open the Podfile and edit as
```Swift
target 'MyPlacesPOC' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyPlacesPOC

  pod 'RealmSwift'

end
```
Now run "pod install". After that open "MyPlacesPOC.xcworkspace". If you are using a Simulator, you can pick a location from your Xcode's debug area.

## TODO
* Use Google Maps SDK
* Allow user to navigate to a placemark



## Image Credits
* Recenter icon made by author "AnhGreen" from http://www.flaticon.com and is licensed by Creative Commons BY 3.0.
(http://www.flaticon.com/authors/anhgreen)

* Edit and Delete Icons made by author "Freepik" from http://www.flaticon.com and is licensed by Creative Commons BY 3.0.
(http://www.freepik.com or http://www.flaticon.com/authors/freepik)

* Add Icon made by author "Madebyoliver" from http://www.flaticon.com and is licensed by Creative Commons BY 3.0.
(http://www.flaticon.com/authors/madebyoliver)

* Up and Down Arrow Icons made by author "Dave Gandy" from http://www.flaticon.com and is licensed by Creative Commons BY 3.0.
(http://www.flaticon.com/authors/dave-gandy)

* Map Icon made by author "Pixel Buddha" from http://www.flaticon.com and is licensed by Creative Commons BY 3.0.
(http://www.flaticon.com/authors/pixel-buddha)
