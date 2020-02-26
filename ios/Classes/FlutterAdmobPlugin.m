#import "FlutterAdmobPlugin.h"
#import <flutter_admob_plugin/flutter_admob_plugin-Swift.h>

@implementation FlutterAdmobPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAdmobPlugin registerWithRegistrar:registrar];
    [AdmobIntersitialPlugin registerWithRegistrar: registrar];
}
@end
