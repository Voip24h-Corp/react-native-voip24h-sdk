# Changelog

## [1.0.4] - 13.11.2025

### Required

- Yêu cầu RN >= 0.77.3

### Update

- Fix policy 16KB page size
- Fix policy Bitcode

## [1.0.3] - 16.06.2025

### Update

- Cài đặt thư viện
	- Android: Trong `build.gradle`:
		```
		...
		allprojects {
			repositories {
				...

				// Loại bỏ
				maven {
					name "linphone.org maven repository"
					url "https://linphone.org/maven_repository/"
					content {
						includeGroup "org.linphone.no-video"
					}
				}

				// Thêm dòng
				flatDir {
					dirs project(':react-native-voip24h-sdk').file('libs')
				}
			}
		}
		```
	- IOS: Trong `ios/Podfile`:
		```
		// Loại bỏ
		pod 'linphone-sdk-novideo', :podspec => '../node_modules/react-native-voip24h-sdk/third_party_podspecs/linphone-sdk-novideo.podspec'
		```

- Thay đổi tên `SipModule` thành `CallModule`, các phương thức tính năng khác vẫn triển khai như cũ trong tài liệu ở [README.md](README.md)
	>
	```
	Example: 

	SipModule.registerSipAccount("extension", "password", "IP")

							~Change to~

	CallModule.registerSipAccount("extension", "password", "IP")
	```
- Graph: 
	- Loại bỏ phương thức `getData` và `getListData`
		> ~~GraphModule.getData(jsonObject)~~ <br>
		~~GraphModule.getListData(jsonObject)~~
	- Thêm cơ chế lấy token dài hạn isLongLive
		> 
		```
		// isLongLive: true/false

		GraphModule.getAccessToken(apiKey, apiSecret, isLongLive, callback)
		```
	- Thay đổi phương thức lấy dữ liệu
		>
		```
		import { GraphRoute } from 'react-native-voip24h-sdk'

		// GraphRoute.CallLog,
		// GraphRoute.Record,
		// GraphRoute.Contact,
		// GraphRoute.AddContact,
		// GraphRoute.UpdateContact,
		// GraphRoute.DeleteContact

		GraphModule.sendRequest(MethodRequest.GET, GraphRoute.Record, token, params, {
			success: (statusCode, message, data) => resolve(data),
			error: (errorCode, message) =>
			console.log(`Error code: ${errorCode}, Message: ${message}`),
		})
		```

### Added

- Thêm tính năng Codecs
	>
	```
	import { Codecs } from 'react-native-voip24h-sdk'

	// Codecs.OPUS,
    // Codecs.SPEEX,
    // Codecs.PCMU,
    // Codecs.PCMA,
    // Codecs.GSM,
    // Codecs.G722,
    // Codecs.ILBC,
    // Codecs.ISAC,
    // Codecs.L16

	CallModule.setCodecs(Codecs.G722, true)
    	.then(() => console.log('Set codecs successfully'))
    	.catch(error => console.log(`Error setting codecs: ${error}`))
	```

## [1.0.2] - 22.03.2023

### Fixed

- Loại bỏ cơ chế init module:
  > ~~SipModule.initializeModule()~~
- Loại bỏ cơ chế Login SIP bằng 3 tham số:
  > ~~SipModule.registerSipAccount("extension", "password", "IP")~~

### Added

- Cơ chế Login SIP mới:

```
import { TransportType, SipConfigurationBuilder } from 'react-native-voip24h-sdk'

var sipConfiguration = new SipConfigurationBuilder('extension','password','ip')
	.setPort(port) // (optional)
	.setTransportType(TransportType.Udp) // Udp, Tcp, Tls, Dtls (optional)
	.setKeepAlive(true) // (optional)
	.build()

SipModule.registerSipAccount(sipConfiguration)
```

- Thêm tính năng Push Notificaion
