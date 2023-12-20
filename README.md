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
$ npm install react-native-voip24h-sdk
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
        $ rm -rf Pods/
        $ pod install
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
- Android
  + Chúng tôi sử dụng Firebase Cloud Messaging (FCM) cho Push Notification. Vì vậy, bạn phải tạo dự án Cloud Messaging trong bảng điều khiển Firebase. Để tạo một dự án Cloud Messaging trong FireBase, đi đến trang https://console.firebase.google.com/
 
- IOS

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
