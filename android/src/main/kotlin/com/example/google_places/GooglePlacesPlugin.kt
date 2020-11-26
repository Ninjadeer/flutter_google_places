package com.example.google_places

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.maps.model.LatLng
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.AutocompleteSessionToken
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.api.model.RectangularBounds
import com.google.android.libraries.places.api.model.TypeFilter
import com.google.android.libraries.places.api.net.FetchPlaceRequest
import com.google.android.libraries.places.api.net.FetchPlaceResponse
import com.google.android.libraries.places.api.net.FindAutocompletePredictionsRequest
import com.google.android.libraries.places.api.net.FindAutocompletePredictionsResponse
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.logging.Logger

/** GooglePlacesPlugin */
class GooglePlacesPlugin : FlutterPlugin, MethodCallHandler {

    private val TAG = "GooglePlacesPlugin"

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "google_places")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "autocomplete") {

            // Initialize the SDK
            Places.initialize(context, "")

            val placesClient = Places.createClient(context)

            val builder = FindAutocompletePredictionsRequest.builder()

            // Create a RectangularBounds object.
            val bounds = RectangularBounds.newInstance(
                    LatLng(-33.8749937, 151.2041382),
                    LatLng(-33.8749937, 151.2041382)
            )

            builder.query = "Tramshed"
            builder.typeFilter = TypeFilter.ESTABLISHMENT
            builder.origin = LatLng(-33.8749937, 151.2041382)
            builder.locationBias = bounds

            // TODO: Need to extend this to accept a custom UUID
            builder.sessionToken = AutocompleteSessionToken.newInstance()

            val request = builder.build()

            var predictions = placesClient.findAutocompletePredictions(request)
                .addOnSuccessListener { response: FindAutocompletePredictionsResponse ->


                    val list = mutableListOf<HashMap<String, Any?>>();

                    for (prediction in response.autocompletePredictions) {

                        val map = hashMapOf<String, Any?>()
                        map["full_text"] = prediction.getFullText(null).toString()
                        map["place_id"] = prediction.placeId
                        map["primary_text"] = prediction.getPrimaryText(null).toString()
                        map["secondary_text"] = prediction.getSecondaryText(null).toString()
                        map["types"] = prediction.placeTypes.map {
                            return@map it.name.toLowerCase()
                        }
                        map["distance"] = prediction.distanceMeters;

                        list.add(map);
                    }
                    result.success(list)

                }.addOnFailureListener { exception: Exception? ->
                    if (exception is ApiException) {
                        Log.e(TAG, "Place not found: " + exception.statusCode)
                    }
                    result.success("error")
                }.addOnCompleteListener {
                    Log.e(TAG, "Complete")
                    Log.e(TAG, it.exception.toString())
                    Log.e(TAG, it.toString())
                };
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
