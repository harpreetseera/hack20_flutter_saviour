import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:saviour/data/issue.dart';
import 'package:saviour/data/location.dart';
import 'package:saviour/ui/screens/event_screen.dart';
import 'package:saviour/ui/screens/issue_screen.dart';
import 'package:saviour/ui/screens/login_screen.dart';
import 'package:saviour/utils/auth_utils.dart';
import 'package:saviour/utils/location_util.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Heatmap> _heatmaps = {};
  StreamSubscription heatPointSubscription;
  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 0,
  );
  LatLng _heatmapLocation = LatLng(37.42796133580664, -122.085749655962);
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    updateCurrentlocation();
    heatPointSubscription =
        Firestore.instance.collection('issues').snapshots().listen((event) {
      updateHeatMap(event);
    });
    super.initState();
  }

  @override
  void dispose() {
    heatPointSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Saviour",
            style: GoogleFonts.fredokaOne(),
          ),
          bottomOpacity: 0.5,
          elevation: 0.5,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  'Logout',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    child: GoogleMap(
                      key: UniqueKey(),
                      mapType: MapType.hybrid,
                      initialCameraPosition: kGooglePlex,
                      heatmaps: _heatmaps,
                      onMapCreated: (GoogleMapController controller) {
                        if (!_controller.isCompleted) {
                          _controller.complete(controller);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:24.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('tip_of_the_day')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) return Offstage();

                          return Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(24,8,24,8),
                                child: Text(
                                    "* TIP OF THE DAY *\n\n${snapshot.data.documents[0]["value"]}",
                                    textAlign: TextAlign.center,),
                              ));
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 100,
                      width: double.maxFinite,
                      // color: Colors.green.withOpacity(0.9),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 0.0,
                              sigmaY: 0.0,
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  OutlineButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: new Text(
                                          "ISSUES",
                                          style: TextStyle(
                                              color: Colors.lightGreen,
                                              fontSize: 18),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    IssueScreen()));
                                      },
                                      borderSide:
                                          BorderSide(color: Colors.lightGreen),
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(15.0))),
                                  OutlineButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: new Text(
                                          "EVENTS",
                                          style: TextStyle(
                                              color: Colors.lightGreen,
                                              fontSize: 18),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EventScreen()));
                                      },
                                      borderSide: BorderSide(
                                        color: Colors.lightGreen,
                                      ),
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(15.0)))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addHeatmap() {
    setState(() {
      _heatmaps.add(Heatmap(
          heatmapId: HeatmapId(_heatmapLocation.toString()),
          points: _createPoints(_heatmapLocation),
          radius: 20,
          visible: true,
          gradient: HeatmapGradient(
              colors: <Color>[Colors.green, Colors.red],
              startPoints: <double>[0.2, 0.8])));
    });
  }

  List<WeightedLatLng> _createPoints(LatLng location) {
    final List<WeightedLatLng> points = <WeightedLatLng>[];
    //Can create multiple points here
    points.add(_createWeightedLatLng(location.latitude, location.longitude, 1));
    points.add(
        _createWeightedLatLng(location.latitude - 1, location.longitude, 1));
    return points;
  }

  WeightedLatLng _createWeightedLatLng(double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void updateCurrentlocation() async {
    Location location = await LocationResult.getLocationNow();
    kGooglePlex = CameraPosition(
      target: LatLng(location.lat, location.long),
      zoom: 1,
    );
    if (mounted) {
      setState(() {});
    }
  }

  void updateHeatMap(QuerySnapshot event) {
    _heatmaps.clear();
    event.documents.forEach((f) {
      Issue issue = Issue.fromMap(f.data);
      LatLng _heatmapLocation =
          LatLng(issue.location.latitude, issue.location.longitude);

      _heatmaps.add(Heatmap(
          heatmapId: HeatmapId(_heatmapLocation.toString()),
          points: _createPoints(_heatmapLocation),
          radius: 20,
          visible: true,
          gradient: HeatmapGradient(
              colors: <Color>[Colors.green, Colors.red],
              startPoints: <double>[0.2, 0.8])));
      if (mounted) {
        setState(() {});
      }
    });
  }

  void handleClick(String value) async {
    if (value == 'Logout') {
      var res = await signOutGoogle();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } else if (value == 'Settings') {}
  }
}
