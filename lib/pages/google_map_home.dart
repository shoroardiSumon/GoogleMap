import 'dart:async';
import 'dart:math';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterMap/bottom_tabs/commute_tab.dart';
import 'package:flutterMap/bottom_tabs/contribute_tab.dart';
import 'package:flutterMap/bottom_tabs/explore_tab.dart';
import 'package:flutterMap/bottom_tabs/saved_tab.dart';
import 'package:flutterMap/bottom_tabs/updates_tab.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import "package:google_maps_webservice/geocoding.dart";
import "package:google_maps_webservice/timezone.dart";
import 'package:flutterMap/utility/constants.dart';
// import 'package:search_map_place/search_map_place.dart';

class GoogleMapHome extends StatefulWidget {
  @override
  _GoogleMapHomeState createState() => _GoogleMapHomeState();
}

const kGoogleApiKey = "AIzaSyBEuPc9JKcjiRY14rlKM3mW0gkU3_ZdPio";
GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey: kGoogleApiKey);

// final homeScaffoldKey = new GlobalKey<ScaffoldState>();
final searchScaffoldKey = new GlobalKey<ScaffoldState>();

class _GoogleMapHomeState extends State<GoogleMapHome> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  final _textEditingController = TextEditingController();

  int _bottomIndex;
  bool _isIt;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _isIt = true;
    _bottomIndex = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  // Bottom Navigation Bar Index------------------------------------------------
  void changePage(int index) {
    setState(() {
      _bottomIndex = index;
    });
  }

  //Get User Location ---------------------------------------------------------
  static LatLng _initialPosition;
  // static LatLng _lastMapPosition = _initialPosition;

  void _getUserLocation() async {
    Position position = await getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });
  }

  // Change Map Type -----------------------------------------------------------
  MapType _defaultMapType = MapType.normal;
  bool isTrue = true;

  void _changeMapType() {
    setState(() {
      _defaultMapType =
          _defaultMapType == MapType.normal ? MapType.hybrid : MapType.normal;
      isTrue = isTrue == true ? false : true;
    });
  }

  // On Camera Move ------------------------------------------------------------
  // _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

  // Create Marker -------------------------------------------------------------
  List<Marker> _marker = [];

  _handleTap(LatLng tappedPoint) {
    print(tappedPoint);
    setState(() {
      _marker = [];
      _marker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          onDragEnd: (dragEndPosition) {
            print(dragEndPosition);
          },
          onTap: () async {
            List<Placemark> placemark = await placemarkFromCoordinates(
                tappedPoint.latitude, tappedPoint.longitude);
            _showModalBottomSheet(context, placemark);
          }));
    });
  }
      

  _showModalBottomSheet(context, List<Placemark> placemark) {
    showModalBottomSheet(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          //borderRadius: BorderRadius.circular(30),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
              alignment: Alignment.center,
              // height: 630,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Address",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Name:  " + placemark[0].name,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Locality:  " + placemark[0].locality,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sublocality:  " + placemark[0].subLocality,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Street:  " + placemark[0].street,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Postal Code:  " + placemark[0].postalCode,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Subadministrative Area:  " +
                          placemark[0].subAdministrativeArea,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Administrative Area:  " +
                          placemark[0].administrativeArea,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Country:  " + placemark[0].country,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 7),
                ],
              ));
        });
  }

  // On Map Created ------------------------------------------------------------
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      //mapController = controller;
      _controller.complete(controller);
    });
  }

  // Search Locations ----------------------------------------------------------

  // _searchNavigate(){

  // }

  void onError(PlacesAutocompleteResponse response) {
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.overlay,
      language: "en",
      components: [Component(Component.country, "en")],
    );

    displayPrediction(p, searchScaffoldKey.currentState);
  }

  List<Widget> _bottomTab = [
    ExploreTab(),
    CommuteTab(),
    SavedTab(),
    ContributeTab(),
    UpdatesTab()
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      key: searchScaffoldKey,
      body: Stack(
        children: <Widget>[
          Scaffold(
            body: _initialPosition == null
                ? Container(
                    child: Center(
                      child: Text(
                        'loading map...',
                        style: TextStyle(
                            fontFamily: 'Avenir-Medium',
                            color: Colors.grey[500]),
                      ),
                    ),
                  )
                : Container(
                    child: Stack(
                      children: <Widget>[
                        GoogleMap(
                          onMapCreated: _onMapCreated,
                          mapType: _defaultMapType,
                          initialCameraPosition: CameraPosition(
                              target: _initialPosition, zoom: 16),
                          //onCameraMove: _onCameraMove,
                          markers: Set.of(_marker),
                          mapToolbarEnabled: true,
                          myLocationEnabled: true,
                          tiltGesturesEnabled: true,
                          rotateGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                          compassEnabled: true,
                          myLocationButtonEnabled: true,
                          buildingsEnabled: true,
                          indoorViewEnabled: true,
                          trafficEnabled: true,
                          padding: EdgeInsets.only(top: kToolbarHeight * 2),
                          onTap: _handleTap,
                        ),
                        Positioned(
                            bottom: kToolbarHeight / 1.5,
                            left: 8.0,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  InkWell(
                                      child: CircleAvatar(
                                        radius: 22,      
                                        backgroundImage: isTrue
                                            ? AssetImage(
                                                ImageStore.satelliteMap)
                                            : AssetImage(ImageStore.normalMap),
                                      ),
                                      onTap: () {
                                        _changeMapType(); 
                                        print('Changing the Map Type');
                                      }),
                                ],
                              ),
                            )),
                        Positioned(
                            top: _isIt == true
                                ? kToolbarHeight * 1.20
                                : kToolbarHeight * 0.75,
                            left: 15,
                            right: 15,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isIt = true;
                                        });
                                        _handlePressButton();
                                        print('Search');
                                      },
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Icon(
                                                Icons.location_on,
                                                color: Colors.green[800],
                                                size: 30,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Container(
                                                  child: Text(
                                                    "Search here",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showMicrophoneDialog(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Icon(
                                        Icons.mic,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showProfileDialog(context);
                                      print("show profile dialog");
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 4, left: 10),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundImage:
                                            AssetImage(ImageStore.userSumon),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
          ),
          Positioned.fill(
            child: _bottomTab[_bottomIndex],
          )
        ],
      ),
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        hasInk: true,
        // inkColor: Colors.black12,
        //fabLocation: BubbleBottomBarFabLocation.end,
        opacity: .2,
        currentIndex: _bottomIndex,
        onTap: (index) {
          changePage(index);
        },
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(
                16)), //border radius doesn't work when the notch is enabled.
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.location_on,
                color: Colors.blueGrey,
              ),
              activeIcon: Icon(
                Icons.location_on,
                color: Colors.deepPurple,
              ),
              title: Text("Explore")),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.location_city,
                color: Colors.blueGrey,
              ),
              activeIcon: Icon(
                Icons.location_city,
                color: Colors.deepPurple,
              ),
              title: Text("Commute")),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.bookmark_border,
                color: Colors.blueGrey,
              ),
              activeIcon: Icon(
                Icons.bookmark_border,
                color: Colors.deepPurple,
              ),
              title: Text("Saved")),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.blueGrey,
              ),
              activeIcon: Icon(
                Icons.add_circle_outline,
                color: Colors.deepPurple,
              ),
              title: Text("Contribute")),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.notifications_none,
                color: Colors.blueGrey,
              ),
              activeIcon: Icon(
                Icons.notifications_none,
                color: Colors.deepPurple,
              ),
              title: Text("Updates"))
        ],
      ),
    );
  }

  void _showMicrophoneDialog(BuildContext context) {
    showDialog(
        context: context,
        child: Theme(
            data: ThemeData.dark(),
            child: CupertinoAlertDialog(
              title: Text('Google\n'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.mic,
                    size: 70,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "English (United States)",
                    style: TextStyle(fontSize: 13),
                  )
                ],
              ),
            )));
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
        context: context,
        child: CupertinoAlertDialog(
          content: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.clear)),
                  Expanded(
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'G',
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                        Text(
                          'o',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        Text(
                          'o',
                          style: TextStyle(color: Colors.orange, fontSize: 20),
                        ),
                        Text(
                          'g',
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                        Text(
                          'l',
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        ),
                        Text(
                          'e',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ],
                    )),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(ImageStore.userSumon),
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Shoroardi Sumon",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "sumonpust7@gmail.com",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.keyboard_arrow_down),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.local_library),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text("Turn on Incognito mode"),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.person_outline),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text('Your Profile'),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.timeline),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text('Youe Timeline'),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.person_add),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text("Location Sharing"),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.cloud_off),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text("Offline maps"),
                    )),
                  ],
                ),
              ),
              Divider(),
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.person_pin_circle),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text("Your data in Maps"),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.settings),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text("Settings"),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.help_outline),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text("Help & feedback"),
                    )),
                  ],
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Icon(
                    Icons.blur_circular,
                    size: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Terms & Services",
                        style: TextStyle(color: Colors.grey[600])),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    scaffold.showSnackBar(
      SnackBar(content: Text("${p.description} - $lat/$lng")),
    );
  }
}

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold()
      : super(
          apiKey: kGoogleApiKey,
          sessionToken: Uuid().generateV4(),
          language: "en",
          components: [Component(Component.country, "uk")],
        );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        displayPrediction(p, searchScaffoldKey.currentState);
      },
      logo: Row(
        children: [FlutterLogo()],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      searchScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Got answer")),
      );
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
