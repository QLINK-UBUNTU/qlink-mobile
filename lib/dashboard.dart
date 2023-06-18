import 'dart:collection';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grock/grock.dart';
import 'package:qlink/Home.dart';
import 'dart:math' as math;
import 'package:qlink/geodesic.dart';
import 'package:provider/provider.dart';
import 'package:qlink/widgets/notifiers.dart';
import 'package:qlink/widgets/lineAnimationWidget.dart';
import 'package:qlink/FirebasedataPage.dart';



class Dashport extends StatefulWidget {
  @override
  _DashportState createState() => _DashportState();
}

class _DashportState extends State<Dashport> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  late LatLng _currentLocation;
  List<LatLng> _locations = [
    LatLng(40.181713, 29.063029), // Bursa VAliliği
    LatLng(40.185695, 29.069731), // Emniyet müdürlüğü
    LatLng(40.263489, 29.058155),  // Kışla
    LatLng(40.199959, 29.060450), // İtfaye
    LatLng(40.193582, 29.076252), // Bursa Belediye
    LatLng(40.196613, 29.050205), // oedaş
    LatLng(40.210995, 29.003027),// ulaşım
    LatLng(40.202104, 29.051213),//Şehir içi indidirici merkez.
    LatLng(40.194232, 29.054666),

  ];

  Set<Polygon> _polygon = HashSet<Polygon>();
  List<List<double>> borderDouble = getBorderBetween(40.181713, 29.063029, 40.185695, 29.069731, 10.0);
  List<LatLng> border = [];
  Future<BitmapDescriptor>? markerBitName;
  @override
  void initState(){
    super.initState();
    getLocation();
    for (List<double> element in borderDouble){
      border.add(LatLng(element[0], element[1]));
    }
    Future.delayed(const Duration(seconds:1));
  }


  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _controller?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLocation,
            zoom: 12.0,
          )

      )
      );
    });


    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/transformer.png",
    );
    int counter = 0;
    for (LatLng position in _locations){
      String name = "Empty";
      switch (counter){
        case 0: {
          name = "Şehiriçi İndirici";
        } break;
        case 1: {
          name = "A Mahallesi";
        } break;
        case 2: {
          name = "B Mahallesi";
        } break;
        case 3: {
          name = "C Mahallesi";
        } break;

        case 4: {
          name = "D Mahallesi";
        } break;
        case 5: {
          name = "E Mahallesi";
        } break;
        case 6: {
          name = "F Mahallesi";
        } break;
        case 7: {
          name = "G Mahallesi";
        } break;
        case 8: {
          name = "H Mahallesi";
        } break;
        case 9: {
          name = "OEDAŞ Trafosu";
        } break;
        case 10: {
          name = "Karakol";
        } break;
        case 11: {
          name = "Kışla";
        } break;
        case 12: {
          name = "Valilik";
        } break;
        case 13: {
          name = "Hastaneler";
        } break;
        case 14: {
          name = "Belediye";
        } break;
        case 15: {
          name = "İtfaiye";
        } break;
      }
      counter ++;

      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(
            title: name,
            snippet: name,
          ),
          icon: markerbitmap,
        )
      );
    }
  }

  double calculateDistance(LatLng start, LatLng end) {
    int radius = 6371000; // Dünya yarıçapı (metre)
    double lat1 = start.latitude * math.pi / 180.0;
    double lon1 = start.longitude * math.pi / 180.0;
    double lat2 = end.latitude * math.pi / 180.0;
    double lon2 = end.longitude * math.pi / 180.0;
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = radius * c;
    return distance;
  }

  void polygonBuilder(LineNotifier lineNotifier, LatLng startingCoordinate_, LatLng endCoordinate_, int connID){
    _polygon.clear();
    _polygon.add(
        Polygon(
          // given polygonId
          polygonId: PolygonId('1'),
          // initialize the list of points to display polygon
          points: border,
          // given color to polygon
          fillColor: lineNotifier.isEnergyActive[connID] ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
          // given border color to polygon
          strokeColor: lineNotifier.isEnergyActive[connID] ? Colors.green : Colors.red,
          geodesic: true,
          // given width of border
          strokeWidth: 4,
        )
    );
    LatLng startingCoordinate = startingCoordinate_;
    LatLng endCoordinate = endCoordinate_;


    if (lineNotifier.isEnergyActive[connID]) {
      for (var i = 0; i < 5; i ++) {
        LatLng beginningCoordinate = LatLng(startingCoordinate.latitude +
            (endCoordinate.latitude - startingCoordinate.latitude) * i / 5,
            startingCoordinate.longitude +
                (endCoordinate.longitude - startingCoordinate.longitude) * i /
                    5);
        LatLng endingCoordinate = LatLng(startingCoordinate.latitude +
            (endCoordinate.latitude - startingCoordinate.latitude) * (i + 1) /
                5, startingCoordinate.longitude +
            (endCoordinate.longitude - startingCoordinate.longitude) * (i + 1) /
                5);

        LatLng currentStartingCoordinate = LatLng(beginningCoordinate.latitude +
            (endingCoordinate.latitude - beginningCoordinate.latitude) *
                lineNotifier.lineAnimationValue,
            beginningCoordinate.longitude +
                (endingCoordinate.longitude - beginningCoordinate.longitude) *
                    lineNotifier.lineAnimationValue);
        LatLng currentEndingCoordinate = LatLng(
            currentStartingCoordinate.latitude +
                (endingCoordinate.latitude - beginningCoordinate.latitude) / 3,
            currentStartingCoordinate.longitude +
                (endingCoordinate.longitude - beginningCoordinate.longitude) /
                    3);
        List<List<double>> lineBorder = getBorderBetween(
            currentStartingCoordinate.latitude,
            currentStartingCoordinate.longitude,
            currentEndingCoordinate.latitude, currentEndingCoordinate.longitude,
            5);

        List<LatLng> latLngLineBorder = [];
        for (List<double> element in lineBorder) {
          latLngLineBorder.add(LatLng(element[0], element[1]));
        }

        _polygon.add(
          Polygon(
            // given polygonId
            polygonId: PolygonId('${beginningCoordinate.latitude}'),
            // initialize the list of points to display polygon
            points: latLngLineBorder,
            // given color to polygon
            fillColor: Colors.yellow,
            // given border color to polygon
            strokeColor: Colors.red,
            geodesic: true,
            // given width of border
            strokeWidth: 2,
          ),
        );
      }
    }
  }

  void cityPoly(LineNotifier lineNotifier) {
    for (var i = 0; i < 8; i++) {
      polygonBuilder(lineNotifier, _locations[0], _locations[i+1], i);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<LineNotifier>(
      builder: (context, lineNotifier, _) {
        cityPoly(lineNotifier);
        return Scaffold(
          backgroundColor: const Color(0xFFE3FFF7),
          appBar: AppBar(
            backgroundColor: const Color(0xFF3AB795),
            title: const Text(
              "Akım Takibi =>",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            actions: <Widget>[
               IconButton(
                icon:  const Icon(Icons.dashboard, color: Color(0XFFE0F5F0), size: 40),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: <Widget>[
                    const FirebaseUpdater(),
                    const LineAnimationHandler(),
                    GoogleMap(
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation,
                        zoom: 12.0,
                      ),
                      polygons: _polygon,
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                      markers: _markers,
                    ),
                  ],
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}


