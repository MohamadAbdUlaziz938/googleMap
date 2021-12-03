import 'dart:convert';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
class Data{
  List<mp.LatLng> polygon;
  Data({required this.polygon});
  String toRawJson()=>json.encode(toJson());
  Map<String,dynamic> toJson(){
    return {
      'polygon':List<Map<String,dynamic>>.from((this.polygon).map((x) => _LatLng(lat: x.latitude,long: x.longitude).toJson())),
    };
  }

}
class _LatLng{
  double? lat;
  double? long;
  _LatLng({this.lat,this.long});
  String toRawJson()=>json.encode(toJson());
  Map<String,dynamic> toJson(){
    return {
    'lat':this.lat,
      'lon':this.long,
    };
  }

}