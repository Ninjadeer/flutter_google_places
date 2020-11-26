#import "GooglePlacesPlugin.h"
#if __has_include(<google_places/google_places-Swift.h>)
#import <google_places/google_places-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "google_places-Swift.h"
#endif

@implementation GooglePlacesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGooglePlacesPlugin registerWithRegistrar:registrar];
}
@end
