import 'package:flutter/cupertino.dart';
import 'package:latlng/latlng.dart';

class MPickerTheme {
  final LatLng initialLocation;
  final double zoom;

  final String lang;

  final String errorAddressMissing;
  final String errorToFindAddress;
  final String withoutAddress;

  final String searchLabel;
  final String searchHint;

  MPickerTheme(
      {@required this.initialLocation,
      this.zoom = 11,
      this.lang,
      this.errorToFindAddress = 'Error to find this address, try again.',
      this.errorAddressMissing = 'Error, address don\'t founded.',
      this.withoutAddress = 'Without Address',
      this.searchHint = 'Type here...',
      this.searchLabel = 'Search:'});
}
