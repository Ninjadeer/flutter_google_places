# Google Places SDK for Android, iOS and web native SDK's

This SDK is intended for providing secure access to the Google Places
API using Flutters platform channels

https://flutter.dev/docs/development/platform-integration/platform-channels

This allows the API key to be restricted to the device or url preventing
unauthorized use of the API key.

## Why have I written this.

Many of the current Google places plugins currently use the Google Places
API directly using a key without restrictions.

With a compiled android application, iOS bundle or Android bundle it is
possible to extract this API key from the code base allowing unhindered
access.

With the web application, this is even easier to download the compiled
javascript to extract the API key

The google api key is 39 characters a-zA-Z0-9 which is trivial to find
with a regex program.


## Android setup

To use Google Places API for android you must setup an API key for the
Android device, this API key will be different to your iOS and Web keys

Navigate to the google credentials screen:

https://console.cloud.google.com/apis/credentials

And create a credential, this will show your API key that you must use
in your Android application, you must then restrict your key to prevent
unauthorized use.


## iOS setup

To use Google Places API for iOS you must setup an API key for the
iOS device, this API key will be different to your Android and Web keys

Navigate to the google credentials screen:

https://console.cloud.google.com/apis/credentials

And create a credential, this will show your API key that you must use
in your iOS application, you must then restrict your key to prevent
unauthorized use.

## Web setup

To use Google Places API for web you must setup an API key for the
iOS device, this API key will be different to your Android and iOS keys

Navigate to the google credentials screen:

https://console.cloud.google.com/apis/credentials

And create a credential, this will show your API key that you must use
in your web application, you must then restrict your key to prevent
unauthorized use.

    <script defer
        src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places&callback=initMap">
    </script>