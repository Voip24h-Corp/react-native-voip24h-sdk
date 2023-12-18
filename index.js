import GraphModule from "./src/GraphModule";
import { MethodRequest, TransportType } from "./src/enum_type/EnumType";
import SipConfigurationBuilder from "./src/model/SipConfiguration";
import { NativeModules } from 'react-native';
import PushNotificationModule from "./src/PushNotificationModule";

const LINKING_ERROR =
  `The package 'react-native-sip-phone' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n'

const SipModule = NativeModules.Voip24hSdk
  ? NativeModules.Voip24hSdk
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR)
        },
      }
    )
 
export { GraphModule, MethodRequest, TransportType, SipModule, SipConfigurationBuilder, PushNotificationModule }