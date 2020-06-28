import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:saviour/data/location.dart';
import 'package:saviour/ui/screens/event_screen.dart';
import 'package:saviour/ui/screens/issue_screen.dart';
import 'package:saviour/utils/location_util.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Heatmap> _heatmaps = {};
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
    updateHeatMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                                color: Colors.black.withOpacity(0.6),
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

  void updateHeatMap() {}
}
