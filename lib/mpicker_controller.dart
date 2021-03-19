import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:rxdart/rxdart.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:dio/dio.dart';
import 'mpicker_address.dart';
import 'mpicker_theme.dart';
import 'dart:core' as c;
import 'dart:core';

class MPickerController with _Base {
  /// # Urls to get geocode infos
  static const _URL_ADDRESS =
      'https://maps.googleapis.com/maps/api/geocode/json?address=[ADDRESS]';
  static const _URL_LAT_LNG =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=[LAT],[LON]';

  final _progress = BehaviorSubject<bool>.seeded(false);
  final _address = BehaviorSubject<MPAddress>();
  final MapController ctMap;
  final MPickerTheme theme;
  final String key;

  final searchControl = TextEditingController();

  Stream<MPAddress> get outStreamAddress => _address.stream;
  Stream<bool> get outStreamProgress => _progress.stream;
  double _scaleStart = 1.0;
  c.bool _hasError = true;
  Offset _dragStart;

  String get currentAddress => _address?.value?.formattedAddress;
  MPAddress get popAddress => _hasError ? null : _address.value;

  MPickerController(
      {@required this.key, @required this.theme, @required this.ctMap});

  /// Go To place with latLng
  goTo(LatLng latLng) => ctMap.center = latLng;

  /// Go To initial place again
  goToInitial() => goTo(theme.initialLocation);

  /// Zoom on double tap
  onDoubleTap() => ctMap.zoom += 0.5;

  /// On Star Change Scale
  onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  /// On Change Scale
  onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      ctMap.zoom += 0.02;
    } else if (scaleDiff < 0) {
      ctMap.zoom -= 0.02;
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart;
      _dragStart = now;
      ctMap.drag(diff.dx, diff.dy);
    }
  }

  /// Here is for web and desktop, when wheel scrolling of mouse, it will apply or remove zoom
  onPointerSignal(PointerSignalEvent e) {
    if (e is PointerScrollEvent) {
      final sl = e.scrollDelta.dy;

      if (sl > 0) {
        // to down
        if (ctMap.zoom > 3) {
          ctMap.zoom -= 0.5;
        }
      } else {
        // to up
        if (ctMap.zoom <= 20.5) {
          ctMap.zoom += 0.5;
        }
      }
    }
  }

  String _replaceIt(
          {@required String text, @required c.Map<String, String> remove}) =>
      remove.keys.fold<String>(
          text, (text, element) => text.replaceAll(element, remove[element]));

  String _getExtraArgs() =>
      (theme.lang != null ? '&language=${theme.lang}' : '') + '&key=$key';

  /// # Get address by LatLnt
  getAddressByLatLng() async {
    final position = ctMap.center;
    _progress.sink.add(true);

    try {
      final resp = await Dio().get(_replaceIt(
          text: _URL_LAT_LNG + _getExtraArgs(),
          remove: {
            '[LAT]': position.latitude.toString(),
            '[LON]': position.longitude.toString()
          }));

      _address.sink.add(
          MPAddress(formattedAddress: _extractAddress(resp), latLng: position));
    } catch (msg) {
      _address.sink.add(MPAddress(
          formattedAddress: theme.errorToFindAddress, latLng: position));
      _hasError = true;
    }

    _progress.sink.add(false);
  }

  /// # Get address by text
  getAddressByAddress(String address) async {
    _progress.sink.add(true);

    try {
      final resp = await Dio().get(_replaceIt(
          text: _URL_ADDRESS + _getExtraArgs(),
          remove: {'[ADDRESS]': address.toString()}));

      goTo(_extractLatLng(resp));
      _address.sink.add(MPAddress(
          formattedAddress: _extractAddress(resp),
          latLng: _extractLatLng(resp)));
    } catch (msg) {
      _address.sink.add(
          MPAddress(formattedAddress: theme.errorToFindAddress, latLng: null));
      _hasError = true;
    }

    _progress.sink.add(false);
  }

  String _extractAddress(Response resp) {
    final emptyAddress = theme.errorAddressMissing;

    try {
      if (resp.data != null && resp.data['status'] == 'OK') {
        final address = resp.data['results'];

        if ((address as List).length > 0) {
          try {
            _hasError = false;
            return address[0]['formatted_address'].toString();
          } catch (msg) {
            _hasError = true;
            return emptyAddress;
          }
        }
      }

      _hasError = true;
      return emptyAddress;
    } catch (msg) {
      _hasError = true;
      return theme.errorToFindAddress;
    }
  }

  LatLng _extractLatLng(Response resp) {
    try {
      if (resp.data != null && resp.data['status'] == 'OK') {
        final address = resp.data['results'];

        if ((address as List).length > 0) {
          final lg = address[0]['geometry']['location'];
          return LatLng(lg['lat'], lg['lng']);
        }
      }
    } catch (msg) {}

    return null;
  }

  @override
  void dispose() {
    _address.close();
    _progress.close();
  }
}

abstract class _Base {
  void dispose();
}
