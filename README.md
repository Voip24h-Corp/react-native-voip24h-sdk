# React Native Voip24h-SDK 

[![NPM version](https://img.shields.io/npm/v/react-native-voip24h-sdk.svg?style=flat)](https://www.npmjs.com/package/react-native-voip24h-sdk)

## Mục lục

- [Tính năng](#tính-năng)
- [Yêu cầu](#yêu-cầu)
- [Cài đặt](#cài-đặt)
- [Sử dụng](#sử-dụng)
- [CallKit](#callkit)
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
Sử dụng npm:
```bash
$ npm install react-native-voip24h-sdk
```
Linking module:
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
// TODO: What to do with the module?
console.log(GraphModule);
console.log(SipModule);
console.log(MethodRequest);
```

## CallKit
| <div style="text-align: center">Chức năng</div> | <div style="text-align: center">Phương thức và tham số</div> | Kết quả trả về và thuộc tính | <div style="text-align: center">Ví dụ<div> |
| :---------------------------------------------- | :----------------------------------------------------------- | :--------------------------: | :----------------------------------------- |
| Khởi tạo                             | SipModule.initializeModule()                          | None |
| Login tài khoản SIP                  | SipModule.registerSipAccount(extension, password, IP) | None |
| Lấy trạng thái đăng kí tài khoản SIP | SipModule.getSipRegistrationState()                   | state: string <br> error: string   | <code> SipModule.getSipRegistrationState() <br>&emsp; .then((state) => /\*TODO\*/) <br>&emsp; .catch((error) => /\*TODO\*/) </code> |
| Logout tài khoản SIP                 | SipModule.unregisterSipAccount()                      | None |
| Refresh kết nối SIP                  | SipModule.refreshRegisterSipAccount()                 | None |
| Gọi đi                               | SipModule.call(phoneNumber)                           | None |
| Ngắt máy                             | SipModule.hangup()                                    | None |
| Chấp nhận cuộc gọi đến               | SipModule.acceptCall()                                | None |
| Từ chối cuộc gọi đến                 | SipModule.decline()                                   | None |
| Transfer cuộc gọi                    | SipModule.transfer("extension")                       | None |
| Lấy call id                          | SipModule.getCallId()                                 | state: string <br> error: string   | <code>SipModule.getCallId() <br>&emsp; .then((callId) => /\*TODO\*/) <br>&emsp; .catch((error) => /\*TODO\*/)</code> |
| Lấy số lượng cuộc gọi nhỡ            | SipModule.getMissedCalls()                            | result: int <br> error: string     | <code>SipModule.getMissedCalls() <br>&emsp; .then((result) => /\*TODO\*/) <br>&emsp; .catch((error) => /\*TODO\*/)</code> |
| Pause cuộc gọi                       | SipModule.pause()                                     | None |
| Resume cuộc gọi                      | SipModule.resume()                                    | None |
| Bật/Tắt mic                          | SipModule.toggleMic()                                 | result: boolean <br> error: string | <code>SipModule.toggleMic() <br>&emsp; .then((result) => /\*TODO\*/) <br>&emsp; .catch((error) => /\*TODO\*/)</code> |
| Trạng thái mic                       | SipModule.isMicEnabled()                              | result: boolean <br> error: string | <code>SipModule.isMicEnabled() <br>&emsp; .then((result) => /\*TODO\*/) <br>&emsp; .catch((error) => /\*TODO\*/)</code> |
| Bật/Tắt loa                          | SipModule.toggleSpeaker()                             | result: boolean <br> error: string | <code>SipModule.toggleSpeaker() <br>&emsp; .then((result) => /\*TODO\*/) <br>&emsp; .catch((error) => /\*TODO\*/)</code> |
| Trạng thái loa                       | SipModule.isSpeakerEnabled()                          | result: boolean <br> error: string | <code>SipModule.isSpeakerEnabled() <br>&emsp; .then((result) => /\*TODO\*/) <br>&emsp; .catch((error) => /\*TODO\*/)</code> |
| Send DTMF                            | SipModule.sendDtmf("number#")                         | None |

### Event listener SIP:
> • đăng kí event dạng object
<br> • đăng kí event trong React.useEffect()

| <div style="text-align: left">Tên sự kiện</div> | <div style="text-align: left">Kết quả trả về và thuộc tính</div> | <div style="text-align: left">Đặc tả thuộc tính</div> |
| :---------------------------------------------- | :--------------------------------------------------------------- | :---------------------------------------------------- |
| AccountRegistrationStateChanged | body = { <br>&emsp; registrationState: string, <br>&emsp; message: string <br> }               | registrationState: trạng thái kết nối của sip (None/Progress/Ok/Cleared/Failed) <br> message: chuỗi mô tả trạng thái</div> |
| Ring                            | body = { <br>&emsp; extension: string, <br>&emsp; phone: string <br>&emsp; type: string <br> } | extension: máy nhánh <br> phone: số điện thoại người (gọi/nhận) <br> type: loại cuộc gọi(inbound/outbound) |
| Up                              | body = { <br>&emsp; callId: string <br> }                                                      | callId: mã cuộc gọi
| Hangup                          | body = { <br>&emsp; duration: long <br> }                                                      | duration: thời gian đàm thoại (milliseconds)
| Paused                          | None
| Resuming                        | None
| Missed                          | body = { <br>&emsp; phone: string, <br>&emsp; totalMissed: int <br> }                          | phone: số điện thoại người gọi <br> totalMissed: tổng cuộc gọi nhỡ
| Error                           | body = { <br>&emsp; message: string <br> }                                                     | message: chuỗi mô tả trạng thái lỗi

### Ví dụ
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

## Graph
> • key và security certificate(secert) do `Voip24h` cung cấp
<br> • request api: phương thức, endpoint. data body tham khảo từ docs https://docs-sdk.voip24h.vn/

| <div style="text-aligns: center">Chức năng</div> | <div style="text-aligns: center">Phương thức</div> | <div style="text-aligns: center">Đặc tả tham số </div> | <div style="text-aligns: center">Kết quả trả về</div> | <div style="text-aligns: center">Đặc tả thuộc tính</div> |
| :-------------------- | :------------------ | :---------------------- | :-------------------- | :-------------------- |
| Lấy access token | GraphModule.getAccessToken(key, secert, callbacks) | • key: string, <br> • secert: string <br> • callbacks = { <br>&emsp; success:(statusCode, message, oauth), <br>&emsp; error:(errorCode, message) <br> } | success = { <br>&emsp; statusCode: int, <br>&emsp; message: string, <br>&emsp; oauth: Object <br> }, <br> error = { <br>&emsp; errorCode: int, <br>&emsp; message: string <br> } | • statusCode: mã trạng thái <br> • oauth: gồm các thuộc tính (token, createAt, expired, isLongAlive) <br> • errorCode: mã lỗi |
| Request API | GraphModule.sendRequest(method, endpoint, token, params, callback) | • method: MethodRequest(MethodRequest.POST, MethodRequest.GET,...) <br> • endpoint: chuỗi cuối của URL request: "call/find", "call/findone",... <br> • token: access token <br> • params: data body dạng object như { offset: 0, limit: 25 } <br> • callbacks = { <br>&emsp; success:(statusCode, message, jsonObject), <br>&emsp; error:(errorCode, message) <br> } | success = { <br>&emsp; statusCode: int, <br>&emsp;message: string, <br>&emsp;jsonObject: Object <br> }, <br> error = { <br>&emsp; errorCode: int, <br>&emsp; message: string <br> } | • statusCode: mã trạng thái <br> • jsonObject: kết quả response dạng json object <br> • errorCode: mã lỗi |
| Lấy data object | GraphModule.getData(jsonObject) | jsonObject: kết quả response | object: Object | object gồm các thuộc tính được mô tả ở dữ liệu trả về trong docs https://docs-sdk.voip24h.vn/ |
| Lấy danh sách data object | GraphModule.getListData(jsonObject) | jsonObject: kết quả response | object: Object | mỗi object gồm các thuộc tính được mô tả ở dữ liệu trả về trong docs https://docs-sdk.voip24h.vn/ |

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