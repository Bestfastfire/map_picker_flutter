import 'package:flutter/foundation.dart';
import 'package:latlng/latlng.dart';

class MPAddress {
  final String formattedAddress;
  final LatLng latLng;

  MPAddress({@required this.formattedAddress, @required this.latLng});
}
