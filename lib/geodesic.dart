import 'dart:math';

double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
  var phi1 = lat1 * (pi / 180);
  var phi2 = lat2 * (pi / 180);
  var deltaLambda = (lon2 - lon1) * (pi / 180);

  var y = sin(deltaLambda) * cos(phi2);
  var x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(deltaLambda);
  var bearing = atan2(y,x);

  return (bearing * 180 / pi + 360) % 360;

}

List<double> calculateNewCoordinates(double lat, double lon, double distanceMeter, double bearingDegree){
  const R = 6371.0;
  const TO_RAD = pi / 180.0;
  const TO_DEG = 180 / pi;

  var distance = distanceMeter / 1000;

  double distanceInRadius = distance / R;
  double bearingInRadians = bearingDegree * TO_RAD;

  double lat1 = lat * TO_RAD;
  double lon1 = lon * TO_RAD;

  double lat2 = asin(sin(lat1) * cos(distanceInRadius) +
                     cos(lat1) * sin(distanceInRadius) * cos(bearingInRadians));

  double lon2 = lon1 + atan2(sin(bearingInRadians) * sin(distanceInRadius) * cos(lat1),
                             cos(distanceInRadius) - sin(lat1) * sin(lat2));

  lat2 = lat2 * TO_DEG;
  lon2 = lon2 * TO_DEG;

  List<double> returnList = [lat2, lon2];

  return returnList;
}

List<List<double>> getBorderBetween(double startPosLat, double startPosLon, double endPosLat, double endPosLon, double width){

  var bearing = calculateBearing(startPosLat, startPosLon, endPosLat, endPosLon);
  List<double> p1 = calculateNewCoordinates(startPosLat, startPosLon, width, bearing + 90);
  List<double> p2 = calculateNewCoordinates(startPosLat, startPosLon, width, bearing - 90);
  List<double> p3 = calculateNewCoordinates(endPosLat, endPosLon, width, bearing + 90);
  List<double> p4 = calculateNewCoordinates(endPosLat, endPosLon, width, bearing - 90);



  List<List<double>> latLngList = [p1, p2, p4, p3];
  return latLngList;
}