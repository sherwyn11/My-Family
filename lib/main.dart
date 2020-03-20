import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'starter_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_dialog.dart';
import 'my_drawer.dart';
import 'family_dialog.dart';
import 'db.dart';
import 'user_dailog.dart';

class MyHomePage extends StatefulWidget {
  final String title = "My Family";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var familyList = new List();
  var updatesList = new List();
  StreamSubscription _locationSubscription;
  GoogleMapController _mapController;
  Location _locationTracker = Location();
  Marker marker1, marker2;
  Circle circle;
  TextEditingController _controller;
  final _db = Firestore.instance;
  Db db = new Db();
  Uint8List data;
  int check = 0;
  int position = 0;
  String name = "";
  String email = "";
  String fam = "";

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/human.png");
    return byteData.buffer.asUint8List();
  }

  static final CameraPosition initialLocation =
      CameraPosition(target: LatLng(19.0760, 72.8777), zoom: 14.47);

  void openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "Hey user!",
        description: "Write an update...",
        buttonText: "Update",
        famEmail: fam,
      ),
    );
  }

  void openFamilyDialog(List fam) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) => FamilyDialog(
        dataVal: fam,
      ),
    );
    moveCamera(result);
  }

  void getFamilyUpdates(int i) async {
    updatesList.clear();
    final data = await _db
        .collection("Families")
        .document(fam)
        .collection("Locations")
        .getDocuments();
    for (var i in data.documents) {
      if (i.documentID != email) {
        updatesList.add(i.data['update']);
      }
    }
    openUdpateDialog(updatesList, i);
  }

  void openUdpateDialog(updatesList, int i) {
    showDialog(
      context: context,
      builder: (BuildContext context) => UserDialog(
        title: familyList[i - 1],
        description: updatesList[i - 1],
        buttonText: "Close",
      ),
    );
  }

  void moveCamera(res) {
    check = 1;
    position = res;
    getFamilyMemberLocation();
  }

  void getFamilyData() async {
    familyList.clear();
    final data = await _db
        .collection("Families")
        .document(fam)
        .collection("Locations")
        .getDocuments();
    for (var i in data.documents) {
      if (i.documentID != email) {
        familyList.add(i.data['name']);
      }
    }
    openFamilyDialog(familyList);
  }

  void getFamilyMemberLocation() async {
    await for (var snapshot in _db
        .collection("Families")
        .document(fam)
        .collection("Locations")
        .snapshots()) {
      int i = 1;
      for (var message in snapshot.documents) {
        if (message.documentID != email) {
          Uint8List imageData = await getMarker();
          familyList.add(message.data['name']);
          updateFamilyMarker(message.data['latitude'],
              message.data['longitude'], imageData, i);
          if (check == 1 && i == position + 1) {
            _mapController.animateCamera(CameraUpdate.newCameraPosition(
                new CameraPosition(
                    target: LatLng(
                        message.data['latitude'], message.data['longitude']),
                    tilt: 0,
                    zoom: 18.00,
                    bearing: 192.84)));
          }
          i = i + 1;
        }
      }
    }
  }

  void getUserData() async {
    var auth = FirebaseAuth.instance;
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      email = user.email;
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .get()
          .then((value) {
        name = value.data['fname'];
        fam = value.data['fam_email'];
      });
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarker(location, imageData);
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              tilt: 0,
              zoom: 18.00,
              bearing: 192.84)));

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_mapController != null) {
          writetoDB(newLocalData.latitude, newLocalData.longitude);
          check = 0;
          getFamilyMemberLocation();
          updateMarker(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission denied");
      }
    }
  }

  void writetoDB(lat, long) {
    _db
        .collection("Families")
        .document(fam)
        .collection("Locations")
        .document(email)
        .updateData({'latitude': lat, 'longitude': long});
  }

  void updateFamilyMarker(double lat, double lng, Uint8List imageData, int i) {
    var markerIdVal = i;
    String mar = markerIdVal.toString();
    final MarkerId markerId = MarkerId(mar);
    double lati = lat;
    double longi = lng;
    LatLng latLng = LatLng(lati.toDouble(), longi.toDouble());
    final Marker marker = Marker(
        markerId: markerId,
        position: latLng,
        draggable: false,
        rotation: 195.0,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        onTap: () {
          getFamilyUpdates(i);
        },
        icon: BitmapDescriptor.fromBytes(imageData));
    setState(() {
      markers[markerId] = marker;
    });
  }

  void updateMarker(LocationData newLocalData, Uint8List imageData) {
    LatLng latLng = LatLng(newLocalData.latitude, newLocalData.longitude);
    var markerIdVal = 0;
    String mar = markerIdVal.toString();
    final MarkerId markerId = MarkerId(mar);
    final Marker marker = Marker(
        markerId: markerId,
        position: latLng,
        rotation: 195.0,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        onTap: () {
          openDialog();
        },
        icon: BitmapDescriptor.fromBytes(imageData));
    setState(() {
      markers[markerId] = marker;
    });
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    getUserData();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        elevation: 5.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.location_searching,
          color: Colors.white,
        ),
        onPressed: () {
          getCurrentLocation();
        },
      ),
      drawer: MyDrawer(name: name),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.people),
              onPressed: () {
                getFamilyData();
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        markers: Set<Marker>.of(markers.values),
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
