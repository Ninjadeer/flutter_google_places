#import "GooglePlacesPlugin.h"
@import GooglePlaces;

@implementation GMSAutocompleteSessionToken (GMSAutocompleteSessionTokenAdditions)
- (NSString *)uuidToString {
    return [NSString stringWithFormat:@"%@", [self valueForKey:(@"_UUID")]];
}
- (void)uuidFromString:(NSString *)string {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:string];
    [self setValue:uuid forKey:@"_UUID"];
}
@end

@implementation GooglePlacesPlugin {
  GMSPlacesClient *_placesClient;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"google_places"
                                  binaryMessenger:[registrar messenger]];
  GooglePlacesPlugin *instance = [[GooglePlacesPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS "
        stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if([@"autocomplete" isEqualToString:call.method]) {
      
      
     
      NSLog(@"Result %@", call.arguments);
      
      [GMSPlacesClient provideAPIKey:@""];
      
      /**
       * Create a new session token. Be sure to use the same token for calling
       * findAutocompletePredictionsFromQuery:, as well as the subsequent place details request.
       * This ensures that the user's query and selection are billed as a single session.
       */
      GMSAutocompleteSessionToken *token = [[GMSAutocompleteSessionToken alloc] init];
      
      if (call.arguments[@"sessionToken"]) {
        [token uuidFromString:call.arguments[@"sessionToken"]];
      }
      
      NSLog(@"Token %@", [token uuidToString]);
      
      // Create a type filter.
      GMSAutocompleteFilter *_filter = [[GMSAutocompleteFilter alloc] init];
      
      if (call.arguments[@"input"]) {
          
      }
      _filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
      
      NSMutableArray *predictions = [@[] mutableCopy];
      
      [[GMSPlacesClient sharedClient] findAutocompletePredictionsFromQuery:call.arguments[@"input"]
      filter:_filter sessionToken:token callback:^(NSArray<GMSAutocompletePrediction *> * _Nullable results, NSError * _Nullable error) {
        if (error != nil) {
          NSLog(@"An error occurred %@", [error localizedDescription]);
          return;
        }
        if (results != nil) {
            
          for (GMSAutocompletePrediction *result in results) {

            NSDictionary *dict = @{
              @"fullText" : result.attributedFullText.string,
              @"primaryText" : result.attributedPrimaryText.string,
              @"secondaryText" : result.attributedSecondaryText.string,
              @"placeId" : result.placeID,
              @"distance" : result.distanceMeters ? result.distanceMeters : [NSNull null]
            };
            [predictions addObject:dict];
          }
        }
          result(predictions);
      }];
      
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
