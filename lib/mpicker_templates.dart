import 'package:flutter/material.dart';
import 'mpicker_theme.dart';

export 'package:latlng/latlng.dart';
import 'map_picker.dart';
export 'map_picker.dart';

class MapPickerTemplate {
  /// # This feature is very useful in desktop or web, how the screen is bigger,
  /// the picker can be just a dialog, then it is done, done just to use.
  static Future<MPAddress> dialogAddressPicker(
      {Widget Function(Function(String address) search) searchBuilder,
      Widget Function(String address, Function done) addressBuilder,
      double aspectRatio = 2,
      Widget progressWidget,
      MPickerTheme theme,
      Widget marker,
      @required BuildContext context,
      String btnCancel = 'Cancel',
      String btnSave = 'Save'}) async {
    final content = MapPicker(
        progressWidget: progressWidget,
        addressBuilder: addressBuilder,
        searchBuilder: searchBuilder,
        marker: marker,
        theme: theme);

    return await showDialog(
        context: context,
        builder: (c) => Container(
            margin: EdgeInsets.only(bottom: 60),
            child: AlertDialog(
                content: AspectRatio(aspectRatio: aspectRatio, child: content),
                actions: [
                  TextButton(
                      child: Text(btnCancel),
                      onPressed: () {
                        Navigator.pop(context);
                        content.dispose();
                      }),
                  TextButton(
                      child: Text(btnSave),
                      onPressed: () async => await content.pop(context))
                ])));
  }
}
