import 'package:flutter/material.dart';
import './../lib/map_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Map Picker', home: MainScreen());
  }
}

class MainScreen extends StatelessWidget {
  final control = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MapPicker.init(
        theme: MPickerTheme(

            /// # Initial Location
            initialLocation: LatLng(-23.572143, -46.613275),

            /// # Text showed when address is not founded
            errorAddressMissing: 'Error, address don\'t founded.',

            /// # Text showed when gets error during find address
            errorToFindAddress: 'Error to find this address, try again.',

            /// # Initial text when don`t has any address selected
            withoutAddress: 'Without Address Picked',

            /// # Here the texts showed in [TextField] case you don`t use a custom
            searchHint: 'Type here...',
            searchLabel: 'Search:',

            /// # Language of return of google maps api
            lang: 'pt-BR'),
        key: 'AIzaSyDOH1nez80tPwRmA2ayUIdrLTC5dkG0Wvc');

    /// # Here a example to get address by a dialog
    return Scaffold(
        body: Center(
            child: ElevatedButton(
                onPressed: () async => print('address: ${await MapPickerTemplate.dialogAddressPicker(

                    /// # Here you can pass your custom widget to put text and search
                    searchBuilder: (search) => Card(child: TextField(decoration: InputDecoration(labelText: 'Search:', hintText: 'Type here...', prefixIcon: IconButton(icon: Icon(Icons.arrow_back_outlined), onPressed: () => Navigator.pop(context)), suffixIcon: IconButton(icon: Icon(Icons.search),

                        /// # To search, just call the method `search` passing the address string
                        onPressed: () => search(control.text))), controller: control)),

                    /// # Here your custom widget to show current selected address
                    addressBuilder: (txt, done) => Card(

                        /// # Case you want put a button here to done the process, you just need call `done` function
                        child: Container(padding: EdgeInsets.all(10), child: Text(txt, textAlign: TextAlign.center))),

                    /// # You can to pass your custom marker here
                    marker: Icon(Icons.location_pin, color: Colors.redAccent, size: 30),

                    /// # Text in negative button
                    btnCancel: 'Cancel',

                    /// # Text in positive button
                    btnSave: 'Save', context: context)}'),
                child: Text('Address Picker'))));
  }
}
