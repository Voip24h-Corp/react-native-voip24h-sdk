#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#import <React/RCTAppSetupUtils.h>

#import <PushKit/PushKit.h>
#import "RNVoipPushNotificationManager.h"
#import "RNCallKeep.h"
#import "Payload.h"

#if RCT_NEW_ARCH_ENABLED
#import <React/CoreModulesPlugins.h>
#import <React/RCTCxxBridgeDelegate.h>
#import <React/RCTFabricSurfaceHostingProxyRootView.h>
#import <React/RCTSurfacePresenter.h>
#import <React/RCTSurfacePresenterBridgeAdapter.h>
#import <ReactCommon/RCTTurboModuleManager.h>

#import <react/config/ReactNativeConfig.h>

@interface AppDelegate () <RCTCxxBridgeDelegate, RCTTurboModuleManagerDelegate> {
  RCTTurboModuleManager *_turboModuleManager;
  RCTSurfacePresenterBridgeAdapter *_bridgeAdapter;
  std::shared_ptr<const facebook::react::ReactNativeConfig> _reactNativeConfig;
  facebook::react::ContextContainer::Shared _contextContainer;
}
@end
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  RCTAppSetupPrepareApp(application);

  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];

  [RNVoipPushNotificationManager voipRegistration];
  
#if RCT_NEW_ARCH_ENABLED
  _contextContainer = std::make_shared<facebook::react::ContextContainer const>();
  _reactNativeConfig = std::make_shared<facebook::react::EmptyReactNativeConfig const>();
  _contextContainer->insert("ReactNativeConfig", _reactNativeConfig);
  _bridgeAdapter = [[RCTSurfacePresenterBridgeAdapter alloc] initWithBridge:bridge contextContainer:_contextContainer];
  bridge.surfacePresenter = _bridgeAdapter.surfacePresenter;
#endif

  UIView *rootView = RCTAppSetupDefaultRootView(bridge, @"example", nil);

  if (@available(iOS 13.0, *)) {
    rootView.backgroundColor = [UIColor systemBackgroundColor];
  } else {
    rootView.backgroundColor = [UIColor whiteColor];
  }

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

#if RCT_NEW_ARCH_ENABLED

#pragma mark - RCTCxxBridgeDelegate

- (std::unique_ptr<facebook::react::JSExecutorFactory>)jsExecutorFactoryForBridge:(RCTBridge *)bridge
{
  _turboModuleManager = [[RCTTurboModuleManager alloc] initWithBridge:bridge
                                                             delegate:self
                                                            jsInvoker:bridge.jsCallInvoker];
  return RCTAppSetupDefaultJsExecutorFactory(bridge, _turboModuleManager);
}

#pragma mark RCTTurboModuleManagerDelegate

- (Class)getModuleClassFromName:(const char *)name
{
  return RCTCoreModulesClassProvider(name);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                      jsInvoker:(std::shared_ptr<facebook::react::CallInvoker>)jsInvoker
{
  return nullptr;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                     initParams:
                                                         (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return nullptr;
}

- (id<RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass
{
  return RCTAppSetupDefaultModuleFromClass(moduleClass);
}

#endif

/* Add PushKit delegate method */
// --- Handle updated push credentials
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type {
  // Register VoIP push token (a property of PKPushCredentials) with server
  [RNVoipPushNotificationManager didUpdatePushCredentials:credentials forType:(NSString *)type];
}

// --- Handle incoming pushes (for ios >= 11)
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void (^)(void))completion {
  
  NSLog(@"didReceiveIncomingPushWithPayload: %@", payload.dictionaryPayload);
  
  NSString *fromNumber = payload.dictionaryPayload[@"from_number"];
  NSString *toNumber = payload.dictionaryPayload[@"to_number"];
  NSString *uuid = [[NSUUID UUID] UUIDString];
  
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [dict setObject:[uuid lowercaseString] forKey:@"uuid"];
  [dict setObject:fromNumber forKey:@"from_number"];
  [dict setObject:toNumber forKey:@"to_number"];
  
  PushPayload *customPayload = [[PushPayload alloc] init];
  customPayload.customDictionaryPayload = dict;
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"voipRemoteNotificationReceived" object:self userInfo:dict];
    [RNVoipPushNotificationManager didReceiveIncomingPushWithPayload:customPayload forType:(NSString *)type];
  });
  
  [RNCallKeep reportNewIncomingCall:uuid handle:@"example" handleType:@"generic" hasVideo:false localizedCallerName:fromNumber supportsHolding:false supportsDTMF:false supportsGrouping:false supportsUngrouping:false fromPushKit:true payload:nil withCompletionHandler:completion];
  completion();
}

//- (void)applicationWillEnterForeground:(UIApplication *)application {
//  [self endBackgroundTask];
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//  [self extendBackgroundRunningTime];
//}
//
//- (void)endBackgroundTask {
//  if (self.backgroundUpdateTask != UIBackgroundTaskInvalid) {
//    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundUpdateTask];
//    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
//  }
//}
//
//- (void)extendBackgroundRunningTime {
//  if (self.backgroundUpdateTask != UIBackgroundTaskInvalid) {
//    return;
//  }
//
//  self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"extendBackgroundRunningTimeForCallKit" expirationHandler:^{
//    [self endBackgroundTask];
//  }];
//
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    [NSThread sleepForTimeInterval:5.0f];
//    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundUpdateTask];
//    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
//  });
//}

@end
