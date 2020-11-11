#import "HealthKitReporterPlugin.h"
#if __has_include(<health_kit_reporter/health_kit_reporter-Swift.h>)
#import <health_kit_reporter/health_kit_reporter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "health_kit_reporter-Swift.h"
#endif

@implementation HealthKitReporterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHealthKitReporterPlugin registerWithRegistrar:registrar];
}
@end
