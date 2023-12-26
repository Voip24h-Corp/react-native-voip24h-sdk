# React Native Voip24h-SDK 

[![NPM version](https://img.shields.io/npm/v/react-native-voip24h-sdk.svg?style=flat)](https://www.npmjs.com/package/react-native-voip24h-sdk)

## Mục lục

- [Tính năng](#tính-năng)
- [Yêu cầu](#yêu-cầu)
- [Cài đặt](#cài-đặt)
- [Sử dụng](#sử-dụng)
- [CallKit](#callkit)
- [Push Notification](#push-notification)
- [Graph](#graph)

## Tính năng
| Chức năng | Mô tả |
| --------- | ----- |
| CallKit   | • Đăng nhập/Đăng xuất/Refresh kết nối tài khoản SIP <br> • Gọi đi/Nhận cuộc gọi đến <br> • Chấp nhận cuộc gọi/Từ chối cuộc gọi đến/Ngắt máy <br> • Pause/Resume cuộc gọi <br> • Hold/Unhold cuộc gọi <br> • Bật/Tắt mic <br> • Lấy trạng thái mic <br> • Bật/Tắt loa <br> • Lấy trạng thái loa <br> • Transfer cuộc gọi <br> • Send DTMF |
| Graph     | • Lấy access token <br> • Request API từ: https://docs-sdk.voip24h.vn/ |

## Yêu cầu
- OS Platform:
    - Android -> `minSdkVersion: 23`
    - IOS -> `iOS Deployment Target: 11`
- Permissions: khai báo và cấp quyền lúc runtime
    - Android: Trong file `AndroidManifest.xml`
        ```
        <uses-permission android:name="android.permission.INTERNET" />
        <uses-permission android:name="android.permission.RECORD_AUDIO"/>
        ```
        
    - IOS: Trong file `Info.plist`
        ```
        <key>NSAppTransportSecurity</key>
    	<dict>
    		<key>NSAllowsArbitraryLoads</key><true/>
    	</dict>
    	<key>NSMicrophoneUsageDescription</key>
	    <string>{Your permission microphone description}</string>
        ```

## Cài đặt
#### Step 1: NPM:
```bash
npm install react-native-voip24h-sdk
```
#### Step 2: Linking module:
- Android: 
    - Trong file `settings.gradle`
        ```
        include ':react-native-voip24h-sdk'
        project(':react-native-voip24h-sdk').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-voip24h-sdk/android')
        ```
    - Trong `build.gradle`:
        ```
        allprojects {
            repositories {
                ...
                maven {
                    name "linphone.org maven repository"
                    url "https://linphone.org/maven_repository/"
                    content {
                        includeGroup "org.linphone.no-video"
                    }
                }
            }
        }
        ```
    - Trong file `app/build.gradle`
        ```
        android {
            ...
            packagingOptions {
                pickFirst 'lib/x86/libc++_shared.so'
                pickFirst 'lib/x86_64/libc++_shared.so'
                pickFirst 'lib/arm64-v8a/libc++_shared.so'
                pickFirst 'lib/armeabi-v7a/libc++_shared.so'
            }
        }
        
        dependencies {
            ...
            implementation project(':react-native-voip24h-sdk')
        }
        ```
- IOS: 
    - Trong `ios/Podfile`:
        ```
        ...
        use_frameworks!
        target 'Your Project' do
            ...
            # Comment dòng use_flipper!()
            # use_flipper!()
            pod 'linphone-sdk-novideo', :podspec => '../node_modules/react-native-voip24h-sdk/third_party_podspecs/linphone-sdk-novideo.podspec'
        end
        ```
    - Trong folder `ios` mở terminal, nhập dòng lệnh:
        ```bash
        rm -rf Pods/
        pod install
        ```
    > Note: Từ react-native vesion > 0.63.0. Nếu build app trên platform ios mà bị lỗi Swift Compiler error: folly/folly-config.h not found -> Could not build Objective-C module 'linphone'.
    <br> • Fix: Trong file Pods/RCT-Folly/folly/portability/Config.h, comment dòng #include <folly/folly-config.h>

## Sử dụng
```
import { NativeEventEmitter } from 'react-native';
import { GraphModule, SipModule, MethodRequest } from 'react-native-voip24h-sdk';

// TODO: To do something with GraphModule, SipModule
```

## CallKit
#### - Thay đổi: [CHANGELOG.md](CHANGELOG.md)
#### - Tính năng
| <div style="text-align: center">Phương thức và tham số</div> | Kết quả trả về và thuộc tính | <div style="text-align: center">Ví dụ<div> |
| :----------------------------------------------------------- | :--------------------------: | :-----------------------------------------: |
| • Khởi tạo: <br> `initializeModule()` | None | `SipModule.initializeModule()` |
| • Login SIP: <br> `registerSipAccount(String, String, String)` | None | `SipModule.registerSipAccount("extension", "password", "IP")` |
| • Trạng thái đăng kí SIP: <br> `getSipRegistrationState()` | state: string <br> error: string | `SipModule.getSipRegistrationState().then(state => {}).catch(error => {})` |
| • Logout SIP: <br> `unregisterSipAccount()` | None | `SipModule.unregisterSipAccount()` |
| • Refresh kết nối SIP: <br> `refreshRegisterSipAccount()` | None | `SipModule.refreshRegisterSipAccount()` |
| • Gọi đi: <br> `call(String)` | None | `SipModule.call("phoneNumber")` |
| • Ngắt máy: <br> `hangup()` | None | `SipModule.hangup()` |
| • Chấp nhận cuộc gọi đến: <br> `acceptCall()` | None | `SipModule.acceptCall()` |
| • Từ chối cuộc gọi đến: <br> `decline()` | None | `SipModule.decline()` |
| • Transfer cuộc gọi: <br> `transfer(String)` | None | `SipModule.transfer("extension")` |
| • Call id: <br> `getCallId()` | state: string <br> error: string | `SipModule.getCallId().then(callId => {}).catch(error => {})` |
| • Số lượng cuộc gọi nhỡ: <br> `getMissedCalls()` | result: int <br> error: string | `SipModule.getMissedCalls().then(result => {}).catch(error => {})` |
| • Pause cuộc gọi: <br> `pause()` | None | `SipModule.pause()` |
| • Resume cuộc gọi: <br> `resume()` | None | `SipModule.resume()` |
| • Bật/Tắt mic: <br> `toggleMic()` | result: boolean <br> error: string | `SipModule.toggleMic().then(result => {}).catch(error => {})` |
| • Trạng thái mic: <br> `isMicEnabled()` | result: boolean <br> error: string | `SipModule.isMicEnabled().then(result => {}).catch(error => {})` |
| • Bật/Tắt loa: <br> `toggleSpeaker()` | result: boolean <br> error: string | `SipModule.toggleSpeaker().then(result => {}).catch(error => {})` |
| • Trạng thái loa: <br> `isSpeakerEnabled()` | result: boolean <br> error: string | `SipModule.isSpeakerEnabled().then(result => {}).catch(error => {})` |
| • Send DTMF: <br> `sendDtmf(String)` | None | `SipModule.sendDtmf("number#")` |

#### - Event listener SIP:
> • Đăng kí event dạng object
<br> • Đăng kí event trong React.useEffect()

| <div style="text-align: left">Tên sự kiện</div> | <div style="text-align: left">Kết quả trả về và thuộc tính</div> | <div style="text-align: left">Đặc tả thuộc tính</div> |
| :---------------------------------------------- | :--------------------------------------------------------------- | :---------------------------------------------------- |
| AccountRegistrationStateChanged | body = { <br>&emsp; registrationState: String, <br>&emsp; message: String <br> }               | • registrationState: trạng thái kết nối của sip (None/Progress/Ok/Cleared/Failed) <br> • message: chuỗi mô tả trạng thái</div> |
| Ring                            | body = { <br>&emsp; extension: String, <br>&emsp; phone: String <br>&emsp; type: String <br> } | • extension: máy nhánh <br> • phone: số điện thoại người (gọi/nhận) <br> • type: loại cuộc gọi(inbound/outbound) |
| Up                              | body = { <br>&emsp; callId: String <br> }                                                      | • callId: mã cuộc gọi
| Hangup                          | body = { <br>&emsp; duration: Long <br> }                                                      | • duration: thời gian đàm thoại (milliseconds)
| Paused                          | None
| Resuming                        | None
| Missed                          | body = { <br>&emsp; phone: String, <br>&emsp; totalMissed: Int <br> }                          | • phone: số điện thoại người gọi <br> • totalMissed: tổng cuộc gọi nhỡ
| Error                           | body = { <br>&emsp; message: String <br> }                                                     | • message: chuỗi mô tả trạng thái lỗi

#### - Ví dụ lắng nghe event callback
```
const callbacks =  {
    AccountRegistrationStateChanged: (body) => console.log(`AccountRegistrationStateChanged -> registrationState: ${body.registrationState} - message: ${body.message}`),
    Ring: (body) => console.log(`Ring -> extension: ${body.extension} - phone: ${body.phone} - type: ${body.type}`),
    Up: (body) => console.log(`Up -> callId: ${body.callId}`),
    Hangup: (body) => console.log(`Hangup -> duration: ${body.duration}`),
    Paused: () => console.log("Paused"),
    Resuming: () => console.log("Resuming"),
    Missed: (body) => console.log(`Missed -> phone: ${body.phone} - Total missed: ${body.totalMissed}`),
    Error: (body) => console.log(`Error -> message: ${body.message}`)
}

React.useEffect(() => {
    let eventEmitter = new NativeEventEmitter(SipModule)
    const eventListeners = Object.entries(callbacks).map(
        ([event, callback]) => {
            return eventEmitter.addListener(event, callback)
        }
    )
    return () => {
        eventListeners.forEach((item) => {
        item.remove();
        })
    };
}, []);
```
## Push Notification

- IOS: Chúng tôi sử dụng Apple Push Notification service (APNs) cho thông báo đẩy cuộc gọi đến khi app ở trạng thái background
  + Step 1: Tạo APNs Auth Key
    - Truy cập [Apple Developer](https://developer.apple.com/account/resources/certificates/list) để tạo Certificates \
      ![9](/assets/9.png)
    - Chọn chứng nhận VoIP Services Certificate
      ![7](/assets/7.png)
    - Chọn ID ứng dụng của bạn. Mỗi ứng dụng bạn muốn sử dụng với dịch vụ VoIP đều yêu cầu chứng chỉ dịch vụ VoIP riêng. Chứng chỉ dịch vụ VoIP dành riêng cho ID ứng dụng cho phép máy chủ thông báo (Voip24h) kết nối với dịch vụ VoIP để gửi thông báo đẩy về ứng dụng của bạn. \
      ![8](/assets/8.png)
    - Download file chứng chỉ và mở bằng Keychain Access \
      ![11](/assets/11.png)
    - Export chứng chỉ sang định dạng .p12 \
      ![12](/assets/12.png)
    - Convert file chứng chỉ .p12 sang định dạng .pem và submit cho [Voip24h](https://voip24h.vn/) cấu hình
      ```
      openssl pkcs12 -in path_your_certificate.p12 -out path_your_certificate.pem -nodes
      ```
  
  + Step 2: Cấu hình project app của bạn để nhận thông báo đẩy cuộc gọi đến -> Từ IOS 10 trở lên, sử dụng CallKit + PushKit
    > - [Callkit](https://developer.apple.com/documentation/callkit/) cho phép hiển thị giao diện cuộc gọi hệ thống cho các dịch vụ VoIP trong ứng dụng của bạn và điều phối dịch vụ gọi điện của bạn với các ứng dụng và hệ thống khác.
    > - [PushKit](https://developer.apple.com/documentation/pushkit) hỗ trợ các thông báo chuyên biệt để nhận các cuộc gọi Thoại qua IP (VoIP) đến.
    
    - Để sử dụng CallKit Framework + PushKit FrameWork, chúng tôi khuyến khích sử dụng thư viện [react-native-callkeep](https://www.npmjs.com/package/react-native-callkeep) và [react-native-voip-push-notification](https://www.npmjs.com/package/react-native-voip-push-notification)
    ```bash
    npm i react-native-voip-push-notification
    npm i react-native-callkeep

    cd ios
    pod install
    ```
    - Tại project của bạn thêm Push Notifications và tích chọn Voice over IP, Background fetch, Remote notifications, Background processing (Background Modes) trong Capabilities.
    ![5](/assets/5.png) ![6](/assets/6.png)
    - Khi khởi động ứng dụng [react-native-voip-push-notification](https://www.npmjs.com/package/react-native-voip-push-notification) sẽ tạo mã thông báo đăng kí cho ứng dụng khách. Sử dụng mã này để đăng kí lên server [Voip24h](https://voip24h.vn/)
    ```
    // App.js
    
    import VoipPushNotification from "react-native-voip-push-notification"
    import { requestNotifications } from 'react-native-permissions'

    ...

    VoipPushNotification.addEventListener('register', (token) => {
    
		// tokenGraph: access token được generate từ API Graph
	        // token: token device pushkit
		// sipConfiguration: thông số sip khi đăng kí máy nhánh
		// os: Platform.OS (android/ios)
		// bundleId: bundle id của ios
		// isProduction: true(production) / false(dev)
		// uniqueId: device mac
	
      	PushNotificationModule.registerPushNotification(tokenGraph, token, sipConfiguration, os, bundleId, true, uniqueId)
    	    .then(response => {
    	        console.log(response.data)
    	    }).catch(error => {
    		console.log(error.response.data.message)
    	    })
    })
    VoipPushNotification.registerVoipToken()
    ```
    > Chúng tôi khuyến khích sử dụng thư viện [react-native-device-info](https://www.npmjs.com/package/react-native-device-info) để lấy mã device mac và bundle id
 
    - Cấp quyền thông báo trên ios
    ```
    // App.js
    
    import { requestNotifications } from 'react-native-permissions'

    requestNotifications(['alert', 'sound']).then(({status, settings}) => {})
    ```
    - Đăng kí nhận thông báo đẩy từ Voip24h Server
    ```
    // App.js
    import RNCallKeep from 'react-native-callkeep'
    import VoipPushNotification from "react-native-voip-push-notification"
    
    React.useEffect(() => {
        ...
	    // Push Notification
	    if(Platform.OS === 'ios') {
	        const options = {
	            ios: {
	                appName: 'example',
	            }
	        }
	        RNCallKeep.setup(options)
	        RNCallKeep.addEventListener('answerCall', ({callUUID}) => {
	            console.log("accept: " + callUUID)
	            AcceptCall()
	        })
	        RNCallKeep.addEventListener('endCall', ({callUUID}) => {
	            console.log("endCall: " + callUUID + " - " + appState.current)
	            if(appState.current.match(/inactive|background/)) {
	                Hangup()
	            } else {
	                Decline()
	            }
	        })
	        VoipPushNotification.addEventListener('notification', (notification) => {
	            console.log('Message handled in the background!', notification)
	            callId = notification.uuid
	            Login()
	        })
	    }
	    ...
	    return () => {
	        ...
	        RNCallKeep.removeEventListener('answerCall')
	        RNCallKeep.removeEventListener('endCall')
	        callId = ''
	    }
	}, [])
    ```
    - Cấu hình ở project ios native
    ```
    // AppDelegate.mm
    
    #import <PushKit/PushKit.h>
    #import "RNVoipPushNotificationManager.h"
    #import "RNCallKeep.h"
    #import "Payload.h"

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
 	  ...
	  [RNVoipPushNotificationManager voipRegistration];
	  ...
	}
 
    ....
    
    - (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type {
	  [RNVoipPushNotificationManager didUpdatePushCredentials:credentials forType:(NSString *)type];
	}
 
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
	    [RNVoipPushNotificationManager didReceiveIncomingPushWithPayload:customPayload forType:(NSString *)type];
	  });
	  
	  [RNCallKeep reportNewIncomingCall:uuid handle:@"example" handleType:@"generic" hasVideo:false localizedCallerName:fromNumber supportsHolding:false supportsDTMF:false supportsGrouping:false supportsUngrouping:false fromPushKit:true payload:nil withCompletionHandler:completion];
	  completion();
	}
    ```
    - Để huỷ đăng kí nhận Push Notification
    ```
    // App.js
    
    import { PushNotificationModule } from 'react-native-voip24h-sdk'

    // sipConfiguration: thông số sip khi đăng kí máy nhánh
    // os: Platform.OS (android/ios)
    // packageId: package id của android / bundle id của ios

    PushNotificationModule.unregisterPushNotification(sipConfiguration, os, packageId)
    	.then(response => {
    	    console.log(response.data)
    	}).catch(error => {
    	    console.log(error.response.data.message)
    	})
    ```

- Android: Chúng tôi sử dụng Firebase Cloud Messaging (FCM) cho thông báo đẩy cuộc gọi đến khi app ở trạng thái background
  + Step 1: Tạo API Token
  	- Tạo dự án trong bảng điều khiển [Firebase](https://console.firebase.google.com/) \
  		![1](/assets/1.png)
	- Đăng kí app Android \
  		![2](/assets/2.png)
  	- Download file google-services.json và thêm Firebase SDK vào project app của bạn \
  		![3](/assets/3.png)
	- Trong Project settings Firebase, tạo token Cloud Messaging API (Legacy) và submit token này cho [Voip24h](https://voip24h.vn/) cấu hình \
  		![4](/assets/4.png)
    
  + Step 2: Cấu hình project app của bạn để nhận thông báo đẩy cuộc gọi đến -> chúng tôi khuyến khích bạn sử dụng thư viện [React Native Firebase](https://rnfirebase.io/messaging/usage)
  	- NPM
	```bash
  	npm install --save @react-native-firebase/app
  	npm install --save @react-native-firebase/messaging
 	```
  	> Theo dõi docs [React Native Firebase](https://rnfirebase.io/messaging/usage) để cấu hình project app của bạn
   
  	- Khi khởi động ứng dụng [React Native Firebase](https://rnfirebase.io/messaging/usage) sẽ tạo mã thông báo đăng kí cho ứng dụng khách. Sử dụng mã này để đăng kí lên server [Voip24h](https://voip24h.vn/)
  	```
   	// App.js
   
   	import { Platform } from 'react-native'
	import { PushNotificationModule } from 'react-native-voip24h-sdk'
   	import messaging from '@react-native-firebase/messaging'
   
   	...
   	
   	await messaging().registerDeviceForRemoteMessages()
   	const token = await messaging().getToken()

	// tokenGraph: access token được generate từ API Graph
   	// token: token device firebase
   	// sipConfiguration: thông số sip khi đăng kí máy nhánh
   	// os: Platform.OS (android/ios)
   	// packageId: package id của android / bundle id của ios
   	// isProduction: true(production) / false(dev)
   	// uniqueId: device mac
   
   	PushNotificationModule.registerPushNotification(tokenGraph, token, sipConfiguration, os, packageId, isProduction, uniqueId)
   	    .then(response => {
   	        console.log(response.data)
	    }).catch(error => {
   	        console.log(error.response.data.message)
	    })
   	```
  	> Chúng tôi khuyến khích sử dụng thư viện [react-native-device-info](https://www.npmjs.com/package/react-native-device-info) để lấy mã device mac và package id
   	
   	- Phiên bản từ Android 13 (SDK 32) trở đi sẽ yêu cầu quyền thông báo để nhận Push Notification https://developer.android.com/develop/ui/views/notifications/notification-permission. Vui lòng cấp quyền runtime POST_NOTIFICATIONS trước khi sử dụng
	- Để nhận được thông báo đẩy khi app ở trạng thái background, cần xử lý bên ngoài logic ứng dụng cụ thể trong your-project/index.js. Khi nhận thông báo đẩy, vui lòng đăng kí lại máy nhánh để nhận tín hiệu cuộc gọi đến
  	```
   	// index.js
   
   	import { SipModule, SipConfigurationBuilder, TransportType } from 'react-native-voip24h-sdk'
	import messaging from '@react-native-firebase/messaging';

   	...
   
   	messaging().setBackgroundMessageHandler(async (remoteMessage) => {
   	    console.log('Message handled in the background!', remoteMessage);
   	    let eventEmitter = new NativeEventEmitter(SipModule)
   	    eventEmitter.addListener('Ring', event => {
   	        // display your notification
   	    });
   	    Login()
   	})

   	function Login() {
	    var sipConfiguration = new SipConfigurationBuilder("extension", "password", "ip")
	        .setPort(port)
	        .setTransportType(TransportType.Udp)
	        .setKeepAlive(true)
	        .build()
   
	    SipModule.registerSipAccount(sipConfiguration)
	}
   	```
	- Để huỷ đăng kí nhận Push Notification
	```
  	// App.js
  
  	import { PushNotificationModule } from 'react-native-voip24h-sdk'

	// sipConfiguration: thông số sip khi đăng kí máy nhánh
  	// os: Platform.OS (android/ios)
  	// packageId: package id của android / bundle id của ios
  
  	PushNotificationModule.unregisterPushNotification(sipConfiguration, os, packageId)
  	    .then(response => {
  	        console.log(response.data)
  	    }).catch(error => {
  	        console.log(error.response.data.message)
  	    })
  	```

## Graph
> • key và security certificate(secert) do `Voip24h` cung cấp
<br> • request api: method, resource-path. data body tham khảo từ docs https://docs-sdk.voip24h.vn/

| <div style="text-aligns: center">Phương thức</div> | <div style="text-aligns: center">Đặc tả tham số </div> | <div style="text-aligns: center">Kết quả trả về</div> |
| :------------------ | :---------------------- | :------------------------- |
| • Lấy access token: <br> `GraphModule.getAccessToken(key, secert, callbacks)` | • key: String, <br> • secert: String <br> • callbacks = { <br>&emsp; success:(statusCode, message, oauth), <br>&emsp; error:(errorCode, message) <br> } | success = { <br>&emsp; statusCode: Int, <br>&emsp; message: String, <br>&emsp; oauth: Object (gồm các thuộc tính: token, createAt, expired, isLongAlive)<br> }, <br> error = { <br>&emsp; errorCode: Int, <br>&emsp; message: String <br> } |
| • Request API: <br> `GraphModule.sendRequest(method, endpoint, token, params, callback)` | • method: MethodRequest(MethodRequest.POST, MethodRequest.GET,...) <br> • resource-path: đường dẫn tài nguyên của URL: "call/find", "call/findone",... <br> • token: access token <br> • params: data body dạng object như { offset: 0, limit: 25 } <br> • callbacks = { <br>&emsp; success:(statusCode, message, jsonObject), <br>&emsp; error:(errorCode, message) <br> } | success = { <br>&emsp; statusCode: Int, <br>&emsp; message: String, <br>&emsp; jsonObject: Object (kết quả response dạng json object)<br> }, <br> error = { <br>&emsp; errorCode: Int, <br>&emsp; message: String <br> } |
| • Lấy data object: <br> `GraphModule.getData(jsonObject)` | jsonObject: kết quả response | object: Object (gồm các thuộc tính được mô tả ở dữ liệu trả về trong docs https://docs-sdk.voip24h.vn/ |
| • Lấy danh sách data object: <br> `GraphModule.getListData(jsonObject)` | jsonObject: kết quả response | object: Object (mỗi object gồm các thuộc tính được mô tả ở dữ liệu trả về trong docs https://docs-sdk.voip24h.vn/) |

## License
```
The MIT License (MIT)

Copyright (c) 2022 VOIP24H

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
