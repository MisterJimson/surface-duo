#import "SurfaceDuoPlugin.h"
#if __has_include(<surface_duo/surface_duo-Swift.h>)
#import <surface_duo/surface_duo-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "surface_duo-Swift.h"
#endif

@implementation SurfaceDuoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSurfaceDuoPlugin registerWithRegistrar:registrar];
}
@end
