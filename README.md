# google_maps_flutter_example

A new Flutter application to demonstrate how to implement flutter google maps in a flutter application and perfoem advanced tasks on it.

## Adding Map To the App

1. Get an API key at https://cloud.google.com/maps-platform/.

2. Enable Google Map SDK for each platform.
   - Go to [Google Developers Console.](https://console.cloud.google.com/)
   - Choose the project that you want to enable Google Maps on.
   - Select the navigation menu and then select "Google Maps".
   - Select "APIs" under the Google Maps menu.
   - To enable Google Maps for Android, select "Maps SDK for Android" in the "Additional APIs" section, then select "ENABLE".
   - To enable Google Maps for iOS, select "Maps SDK for iOS" in the "Additional APIs" section, then select "ENABLE".
   - Make sure the APIs you enabled are under the "Enabled APIs" section.

3. In `android/app/src/main/AndroidManifest.xml` inside `Application tag` add your key
```xml
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```

4. In `ios/Runner/AppDelegate.swift` add the following lines
```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```
5. Use the `GoogleMapsWidget.dart` inside the `lib/widget` folder as normal widget and use it where you want.




## Adding Custom Marker To the map
<img src="/screenshots/custom_marker_screen.png" width="600">

### Adding normal marker

1. Declare a Set of Markers that will be shown on the map
```dart
Set<Marker> _markers = Set<Marker>();
```

2. Add the set of markers to GoogleMap widget
```dart
GoogleMap(
      markers: _markers,
```

3. Update the set of markers after the map is created in **onMapCreated**
```dart
GoogleMap(
      onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _setMapPins([LatLng(30.029585, 31.022356)]);
            }
```

4. Using this function the map will be updated with the given markers on it
```dart
_setMapPins(List<LatLng> markersLocation) {
    _markers.clear();
    setState(() {
      markersLocation.forEach((markerLocation) {
        _markers.add(Marker(
          markerId: MarkerId(markerLocation.toString()),
          position: markerLocation,
        ));
      });
    });
  }
```

### Customizing the markers

1. Declare a BitmapDescriptor which will hold the customIcon
```dart
late BitmapDescriptor customIcon;
```

2. Inside **initState()** Assign the needed png to the **customIcon**
```dart
@override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(50, 50)),
            'assets/images/marker_car.png')
        .then((icon) {
      customIcon = icon;
    });
    super.initState();
  }
```

3. Finally add the **customIcon** to the marker
```dart
Marker(
     markerId: MarkerId(markerLocation.toString()),
     position: markerLocation,
     icon: customIcon,
   )
```


## Map Customization (Light/Dark mode)
<img src="/screenshots/map_dark_light.png" width="600">

### Prepare the map styles
1. Go to https://mapstyle.withgoogle.com/
2. Choose the old version of the site by choosing **No thanks, take me to the old style wizard**
3. You will find a lot of options, play with it until you get the desired style.
4. Click Finish and a pop-up will show with the json code of your style, copy it and add it as a json file in your assets folder
**Don't forgot to mention it in your pubspec.yaml**
**You can find two styles in the project's assets folder**

### Adding styles to the map
1. Declare Strings that will hold your style's json and a bool to control which mode is shown on the map
```dart
bool mapDarkMode = true;
late String _darkMapStyle;
late String _lightMapStyle;
```
2. In initState declare the styles
```dart
Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_style/dark.json');
    _lightMapStyle = await rootBundle.loadString('assets/map_style/light.json');
  }
```
3. After creating the map, set the style
```dart
onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _setMapPins([LatLng(30.029585, 31.022356)]);
          _setMapStyle();
        },
```
```dart
Future _setMapStyle() async {
    final controller = await _controller.future;
    if (mapDarkMode)
      controller.setMapStyle(_darkMapStyle);
    else
      controller.setMapStyle(_lightMapStyle);
  }
```
4. To change the style we created a button on the map using the stack widget
```dart
Positioned(
   top: 100,
   right: 30,
   child: Container(
     height: 30,
     width: 30,
     child: IconButton(
       icon: Icon(
         mapDarkMode ? Icons.brightness_4 : Icons.brightness_5,
         color: Theme.of(context).primaryColor,
       ),
       onPressed: () {
         setState(() {
           mapDarkMode = !mapDarkMode;
           _setMapStyle();
         });
       },
     ),
   )),
```


## Drawing routes
<img src="/screenshots/routing.jpg" width="600">

### Activating Directions API
1. Go to [Google Developers Console.](https://console.cloud.google.com/)
2. Choose the project that you want to enable Google Maps on.
3. Select the navigation menu and then select "Google Maps".
4. Select "APIs" under the Google Maps menu.
5. Enable Google Directions, select "Directions API" in the "Additional APIs" section, then select "ENABLE".
6. Make sure the APIs you enabled are under the "Enabled APIs" section.

### Adding route to the map
1. Declare your start and end points
```dart
final LatLng initialLatLng = LatLng(30.029585, 31.022356);
final LatLng destinationLatLng = LatLng(30.060567, 30.962413);
```
2. Declare polyline and polylineCoordinates
```dart
Set<Polyline> _polyline = {};
List<LatLng> polylineCoordinates = [];
```
3. After creating the map, set the polyline
```dart
onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _setMapPins([LatLng(30.029585, 31.022356)]);
          _setMapStyle();
          _addPolyLines();
        },
```
```dart
_addPolyLines() {
    setState(() {
      lat = (initialLatLng.latitude + destinationLatLng.latitude)/2;
      lng= (initialLatLng.longitude + destinationLatLng.longitude)/2;
      _moveCamera(13.0);
      _setPolyLines();
    });
  }
```
4. To set polyline we send a get request to https://www.maps.googleapis.com/maps/api/directions/json with the start location, end location and the api key
```dart
final result = await MapRepository()
        .getRouteCoordinates(initialLatLng, destinationLatLng);
final route = result.data["routes"][0]["overview_polyline"]["points"];
```
5. Then we translate the results to a polyline using the MapUtils
```dart
_polyline.add(Polyline(
    polylineId: PolylineId("tripRoute"),
    //pass any string here
    width: 3,
    geodesic: true,
    points: MapUtils.convertToLatLng(MapUtils.decodePoly(route)),
    color: Theme.of(context).primaryColor));
```


## Live Location
<img src="/screenshots/live_location.png" width="600">

### Preparing the app
1. Add [location: ^4.3.0](https://pub.dev/packages/location) in pubspec.yaml file

2. In `android/app/src/main/AndroidManifest.xml` add the following permissions
```xml
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
```

3. In `android/app/build.gradle` increase the minSdkVersion to 20

4. In `ios/runner/info.plist` add the following lines
```plist
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>we will use this to get user location</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>we will use this to get user location</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>we will use this to get user location</string>
```

### Current location service
In the services folder you can find [current_location_service.dart](/lib/services/current_location_service.dart) where we enable the service
 ```dart
 serviceEnabled = await  location.serviceEnabled();
     if(!serviceEnabled){
       serviceEnabled = await location.requestService();
     }
 ```
 and listen to location changes 
 ```dart
  currentLocationStream =
              location.onLocationChanged.listen((LocationData currentLocation) {
                return AppBloc.liveLocationCubit.updateUserLocation(currentLocation);
              });
 ```
 after getting the permission.
 ```dart
   PermissionStatus isGranted = await location.hasPermission();
       if (isGranted == PermissionStatus.granted )
         return true;
       else {
         PermissionStatus requestResult = await location.requestPermission();
         if (requestResult == PermissionStatus.granted)
           return true;
         return false;
       }
 ```
 
 
Note that for deployment, you need to tell the user (through UI) that you will be collecting his location even when the app is in background.

### Using the current location service
 - Using any state management you prefer [(Here using BLoC/Cubit)](/lib/controller/live_location_cubit.dart) to control the service
 - Every change in the service triggers the controller to update the UI
 ```dart
    AppBloc.liveLocationCubit.updateUserLocation(currentLocation);
```
 - In your UI [(Here google_maps_widget.dart)](/lib/widgets/google_maps_widget.dart) listen to the controller changes and update UI
 ```dart
   BlocListener<LiveLocationCubit, LocationData?>(
           listener: (context, liveLocation) {
             if (liveLocation != null) {
               _updateUserMarker(liveLocation);
             }
           },
``` 
```dart
   _updateUserMarker(LocationData currentLocation) {
       if (currentLocation.latitude != null && currentLocation.longitude != null) {
         _markers.removeWhere((marker) => marker.markerId.value == 'user');
         lat = currentLocation.latitude!;
         lng = currentLocation.longitude!;
         _moveCamera();
         setState(() {
           _markers.add(Marker(
               markerId: MarkerId('user'),
               position: LatLng(currentLocation.latitude!, currentLocation.longitude!)));
         });
       }
     }
```
