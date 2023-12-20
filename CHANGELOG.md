# Changelog

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
