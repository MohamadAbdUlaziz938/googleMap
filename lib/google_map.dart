import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
class GooleMap extends StatefulWidget {
  const GooleMap({Key? key, required this.locationData}) : super(key: key);
  final LocationData locationData;
  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GooleMap> {
  LocationData? locationData;
  Set<gm.Marker> _markers = HashSet<gm.Marker>();
  Set<gm.Polygon> _polygons = HashSet<gm.Polygon>();
  Set<gm.Circle> _circles = HashSet<gm.Circle>();
  List<gm.LatLng> _polygonLatLngs = <gm.LatLng>[];
  double? radius;

  int _polygonIdCounter = 1;
  int _circleIdCounter = 1;
  int _markerIdCounter = 1;

  bool _isPolygon = true;
  bool _isMarker = false;
  bool _isCircle = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationData = widget.locationData;
  }

  void setMarker(gm.LatLng point) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    setState(() {
      print('Marker|latitude: ${point.latitude} longitude: ${point.longitude}');
      _markers.add(
        gm.Marker(markerId: gm.MarkerId(markerIdVal), position: point),
      );
    });
  }

  void setCircles(gm.LatLng point) {
    final String circleIdVal = 'circle_id_$_circleIdCounter';
    _circleIdCounter++;
    print(
        'Circle| latitude: ${point.latitude} longitude:${point.longitude} raduis: ${radius}');
    _circles.add(gm.Circle(
        circleId: gm.CircleId(circleIdVal),
        center: point,
        radius: radius!,
        fillColor: Colors.redAccent.withOpacity(0.5),
        strokeWidth: 3,
        strokeColor: Colors.redAccent));

    setState(() {});
  }

  void setPolygon() {
    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygons.add(gm.Polygon(
        polygonId: gm.PolygonId(polygonIdVal),
        points: _polygonLatLngs ,
        strokeWidth: 2,
        strokeColor: Colors.yellowAccent,
        fillColor: Colors.yellowAccent.withOpacity(0.15)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            gm.GoogleMap(
              initialCameraPosition: gm.CameraPosition(
                  target:
                  gm.LatLng(locationData!.latitude!, locationData!.longitude!),
                  zoom: 16),
              mapType: gm.MapType.normal,
              markers: _markers,
              circles: _circles,
              polygons: _polygons,
              myLocationEnabled: true,
              onTap: (point) {
                if (_isPolygon) {
                  setState(() {
                    print('pol');
                    _polygonLatLngs.add(point);
                    setPolygon();
                  });
                } else if (_isMarker) {
                  List<mp.LatLng> pol=<mp.LatLng>[];
                  _polygonLatLngs.map((e) => pol.add(mp.LatLng(e.latitude,e.longitude))).toList();
                  if(mp.PolygonUtil.containsLocation(mp.LatLng(point.latitude,point.longitude),pol,true ))
                  setState(() {
                    _markers.clear();
                    setMarker(point);
                  });
                } else if (_isCircle) {
                  setState(() {
                    _markers.clear();
                    gm.LatLng val=gm.LatLng(33.513807299999996, 36.2765279);
                    setCircles(val);
                  });
                } else if (_isCircle) {
                  setState(() {
                    _circles.clear();
                    setCircles(point);
                  });
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _isPolygon = true;
                        _isCircle = false;
                        _isMarker = false;
                      });
                    },
                    color: Colors.black54,
                    child: Text(
                      'polygon',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _isPolygon = false;
                        _isCircle = false;
                        _isMarker = true;
                      });
                    },
                    color: Colors.black54,
                    child: Text(
                      'marker',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {

                      setState(() {
                        _isPolygon = false;
                        _isCircle = true;
                        _isMarker = false;
                        radius = 50;
                      });
                    },
                    color: Colors.black54,
                    child: Text(
                      'circle',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
