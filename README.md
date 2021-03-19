# Map Picker Flutter
Check it out at [Pub.Dev](https://pub.dev/packages/map_picker_flutter)

![Screenshot_354](https://user-images.githubusercontent.com/22732544/111829863-009e1c80-88cc-11eb-9dc1-0e6dc3cfab59.png)

## Help Maintenance

I've been maintaining quite many repos these days and burning out slowly. If you could help me cheer up, buying me a cup of coffee will make my life really happy and get much energy out of it.

<a href="https://www.buymeacoffee.com/RtrHv1C" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>

## Objective
This lib was designed especially for web and desktop platforms, but of course you can also use it on mobiles.

## Getting Started
To use is simple, before all, you need to call this method, It will required once only,

    MapPicker.init(
            /// Custom search Builder Widget, case it is null, will be used the default of packer
            searchBuilder: (Function(String address) search) => MyCustomWidget(),

            /// Custom address Builder Widget, case it is null, will be used the default of packer
            addressBuilder: (String address, Function done) => MyCustomWidget(),

            /// Custom progress Widget, case it is null, will be used the default of packer
            progressWidget: MyCustomWidget(),

            /// Custom address Builder Widget, case it is null, will be used the default of packer
            marker: MyCustomWidget(),

            /// All above is to set global widgets to all times you need call this package

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
                lang: 'en'),

            /// My Google Maps Api Key
            key: 'GOOGLE_API_KEY');

# Then Usage

Now you can use of two ways

## Mobiles

You just call navigator and wait to response, ex:

    final MPAddress address = await Navigator.push(context, MaterialPageRoute(builder: (c) => MapPicker(
        /// here, case you want overwrite anything of global params of you set, you can

        /// # Custom search Builder Widget, case it is null, will be used the global or default
        searchBuilder: (Function(String address) search) => MyCustomWidget(),

        /// # Custom address Builder Widget, case it is null, will be used the global or default
        addressBuilder: (String address, Function done) => MyCustomWidget(),

        /// # Custom progress Widget, case it is null, will be used the global or default
        progressWidget: MyCustomWidget(),

        /// # Custom theme, case it is null, will be used the global or default
        theme: MPickerTheme(...),

        /// # Custom Marker, case it is null, will be used the global or default
        marker: MyWidget()
    )));

## Web / Desktop

In this platforms, because screens is bigger, I think is more intelligent use a dialog, then I made it ready for you to use

    final MPAddress address = await MapPickerTemplate.dialogAddressPicker(
        context: context);

Of course, you can use both ways on any platform, this is just a suggestion.