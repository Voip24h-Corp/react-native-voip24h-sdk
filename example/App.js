/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React from 'react'
import type { Node } from 'react'
import { NativeModules, Platform, NativeEventEmitter } from 'react-native'
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
  Button,
  AppState
} from 'react-native'

import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen'

import {
  GraphModule,
  SipModule,
  MethodRequest,
  TransportType,
  SipConfigurationBuilder,
  PushNotificationModule,
} from 'react-native-voip24h-sdk'

import messaging from '@react-native-firebase/messaging'
import { NotificationUtils } from './src/utils/NotificationUtils'
import RNCallKeep from 'react-native-callkeep'
import VoipPushNotification from "react-native-voip-push-notification"
import { requestNotifications } from 'react-native-permissions'
import uuid from 'react-native-uuid'
import DeviceInfo from 'react-native-device-info';

const Section = ({children, title}): Node => {
  const isDarkMode = useColorScheme() === 'dark'
  return (
    <View style={styles.sectionContainer}>
      <Text
        style={[
          styles.sectionTitle,
          {
            color: isDarkMode ? Colors.white : Colors.black,
          },
        ]}>
        {title}
      </Text>
      <Text
        style={[
          styles.sectionDescription,
          {
            color: isDarkMode ? Colors.light : Colors.dark,
          },
        ]}>
        {children}
      </Text>
    </View>
  )
}

const key = 'c3a80157b2852e9bdbe80e1260b5a6fc645fb77b'
const secert = '8a2a1c20bf4abe3fb1ed29a3cd1d449af3dd58ad'
let callId = ''
let tokenGraph = ''

const App: () => Node = () => {
  const isDarkMode = useColorScheme() === 'dark'

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  }

  const [result, setResult] = React.useState(1)
  const appState = React.useRef(AppState.currentState);
  const [appStateVisible, setAppStateVisible] = React.useState(appState.current);

  const fetchToken = async () => {
    return new Promise(function (resolve) {
      GraphModule.getAccessToken(key, secert, {
        success: (statusCode, message, oauth) => resolve(oauth.token),
        error: (errorCode, message) =>
          console.log(`Error code: ${errorCode}, Message: ${message}`),
      })
    })
  }

  const fetchData = async (token: string, params: object) => {
    return new Promise(function (resolve) {
      GraphModule.sendRequest(MethodRequest.POST, 'call/find', token, params, {
        success: (statusCode, message, jsonObject) => resolve(jsonObject),
        error: (errorCode, message) =>
          console.log(`Error code: ${errorCode}, Message: ${message}`),
      })
    })
  }

  const onPress = async () => {
    const jsonRequest = {
      offset: 0,
      limit: 10
    }
    var jsonObject = await fetchData(tokenGraph, jsonRequest)
    var dataList = GraphModule.getListData(jsonObject)
    console.log(dataList)
    // var data = GraphModule.getData(jsonObject);
    // console.log(data);
  }

  const GetToken = async () => {
    tokenGraph = await fetchToken()
    console.log(tokenGraph)
  }

  var sipConfiguration = new SipConfigurationBuilder(
    'extension',
    'password',
    'ip'
  )
    .setPort(port)
    .setTransportType(TransportType.Udp)
    .setKeepAlive(true)
    .build()

  const Login = () => {
    // console.log(sipConfiguration);
    SipModule.registerSipAccount(sipConfiguration)
  }

  const Call = () => {
    SipModule.call('phone number')
  }

  const Hangup = () => {
    SipModule.hangup()
  }

  const AcceptCall = () => {
    SipModule.acceptCall()
  }

  const Decline = () => {
    SipModule.decline()
  }

  const ToggleMic = () => {
    SipModule.toggleMic()
      .then(result => {
        if (result) console.log('Enabled mic')
        else console.log('Disabled mic')
      })
      .catch(error => console.log(error))
  }

  const Pause = () => {
    SipModule.pause()
  }

  const Resume = () => {
    SipModule.resume()
  }

  const Transfer = () => {
    SipModule.transfer('extension')
  }

  const ToggleSpeaker = () => {
    SipModule.toggleSpeaker()
      .then(result => {
        if (result) console.log('Enabled speaker')
        else console.log('Disabled speaker')
      })
      .catch(error => console.log(error))
  }

  const SendDtmf = () => {
    SipModule.sendDtmf('number#')
  }

  const Logout = () => {
    SipModule.unregisterSipAccount()
  }

  const RefreshRegister = () => {
    SipModule.refreshRegisterSipAccount()
  }

  const GetCallID = () => {
    SipModule.getCallId()
      .then(callId => console.log(`Call ID: ${callId}`))
      .catch(error => console.log(error))
  }

  const GetSipRegistrationState = () => {
    SipModule.getSipRegistrationState()
      .then(state => console.log(`State: ${state}`))
      .catch(error => console.log(error))
  }

  const GetMissedCall = () => {
    SipModule.getMissedCalls()
      .then(state => console.log(`Missed calls: ${state}`))
      .catch(error => console.log(error))
  }

  const GetMicEnable = () => {
    SipModule.isMicEnabled()
      .then(result => console.log(`Mic enabled: ${result}`))
      .catch(error => console.log(error))
  }

  const GetSpeakerEnable = () => {
    SipModule.isSpeakerEnabled()
      .then(result => console.log(`Speaker enabled: ${result}`))
      .catch(error => console.log(error))
  }

  // console.log(NativeModules.Voip24hSdk)
  // SipModule.initializeModule();
  // var sipConfiguration = new SipConfigurationBuilder('extension','password','ip',)
  //   .setPort(port)
  //   .setTransportType(TransportType.Udp)
  //   .setKeepAlive(true)
  //   .build()

  const callbacks = {
    AccountRegistrationStateChanged: body => console.log(`AccountRegistrationStateChanged -> registrationState: ${body.registrationState} - message: ${body.message}`),
    Ring: body => {
      console.log(`Ring -> extension: ${body.extension} - phone: ${body.phone} - type: ${body.type}`)
      if(body.type === 'inbound') {
        if(Platform.OS === 'ios') {
          if(callId !== '') {
            // Update infomation from push notification Voip24h Server
            RNCallKeep.updateDisplay(callId, body.phone, '')
          } else {
            // Display notification when app foreground
            const uuidNotification = uuid.v4()
            callId = uuidNotification
            RNCallKeep.displayIncomingCall(uuidNotification, 'example', localizedCallerName = body.phone, handleType = 'generic', hasVideo = false, options = null)
          }
        } else {
          NotificationUtils.displayIncomingCallNotification(body.phone)
        }
      }
    },
    Up: body => console.log(`Up -> callId: ${body.callId}`),
    Hangup: body => {
      console.log(`Hangup -> duration: ${body.duration}`)
      RNCallKeep.endAllCalls()
      callId = ''
    },
    Paused: () => console.log('Paused'),
    Resuming: () => console.log('Resuming'),
    Missed: body => console.log(`Missed -> phone: ${body.phone} - Total missed: ${body.totalMissed}`),
    Error: body => console.log(`Error -> message: ${body.message}`),
  }

  React.useEffect(() => {
    AppState.addEventListener('change', _handleAppStateChange);

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
    } else {
      NotificationUtils.observeNotifitionForegroundForAndroid()
    }

    let eventEmitter = new NativeEventEmitter(SipModule)
    const eventListeners = Object.entries(callbacks).map(
      ([event, callback]) => {
        return eventEmitter.addListener(event, callback)
      },
    )
    return () => {
      eventListeners.forEach(item => {
        item.remove()
      })
      AppState.removeEventListener('change', _handleAppStateChange)
      RNCallKeep.removeEventListener('answerCall')
      RNCallKeep.removeEventListener('endCall')
      callId = ''
    }
  }, [])

  const RegisterPushNotificationIOS = async () => {
    VoipPushNotification.addEventListener('register', (token) => {
      console.log(token)
      let bundleId = DeviceInfo.getBundleId()
      console.log(bundleId)
      DeviceInfo.getUniqueId().then((uniqueId) => {
        console.log(uniqueId)
        PushNotificationModule.registerPushNotification(tokenGraph, token, sipConfiguration, Platform.OS, bundleId, false, uniqueId)
          .then(response => {
            console.log(response.data)
          }).catch(error => {
            console.log(error.response.data.message)
          })
      })
    })
    VoipPushNotification.registerVoipToken();
  }

  const RegisterPushNotificationAndroid = async () => {
    await messaging().registerDeviceForRemoteMessages()
    const token = await messaging().getToken()
    // console.log(token)
    let packageId = DeviceInfo.getBundleId()
    // console.log(packageId)
    DeviceInfo.getUniqueId().then((uniqueId) => {
      // console.log(uniqueId)
      PushNotificationModule.registerPushNotification(tokenGraph, token, sipConfiguration, Platform.OS, packageId, true, uniqueId)
        .then(response => {
          console.log(response.data)
        }).catch(error => {
          console.log(error.response.data.message)
        })
    })
  }

  const UnRegisterPushNotification = async () => {
    let packageId = DeviceInfo.getBundleId()
    PushNotificationModule.unregisterPushNotification(sipConfiguration, Platform.OS, packageId)
      .then(response => {
        console.log(response.data)
      }).catch(error => {
        console.log(error.response.data.message)
      })
  }

  requestNotifications(['alert', 'sound']).then(({status, settings}) => {});

  const _handleAppStateChange = nextAppState => {
    appState.current = nextAppState
    setAppStateVisible(appState.current)
  }

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <ScrollView
        contentInsetAdjustmentBehavior='automatic'
        style={backgroundStyle}>
        <Header />
        <View
          style={{
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
          }}>
          <Button onPress={GetToken} title='Get Token Graph' />
          <Button onPress={onPress} title='Example Graph' />
          <Button
            onPress={RegisterPushNotificationAndroid}
            title='Register Push Notification for Android'
          />
          <Button
            onPress={RegisterPushNotificationIOS}
            title='Register Push Notification for IOS'
          />
          <Button
            onPress={UnRegisterPushNotification}
            title='UnRegister Push Notification'
          />
          <Button onPress={Login} title='Login' />
          <Button onPress={Logout} title='Logout' />
          <Button onPress={RefreshRegister} title='Refresh register' />
          <Button onPress={Call} title='Call' />
          <Button onPress={Hangup} title='Hangup' />
          <Button onPress={AcceptCall} title='Accept Call' />
          <Button onPress={Decline} title='Decline' />
          <Button onPress={Pause} title='Pause' />
          <Button onPress={Resume} title='Resume' />
          <Button onPress={Transfer} title='Transfer' />
          <Button onPress={ToggleMic} title='ToggleMic' />
          <Button onPress={ToggleSpeaker} title='ToggleSpeaker' />
          <Button onPress={SendDtmf} title='Send dtmf' />
          <Button onPress={GetCallID} title='Get CallID' />
          <Button onPress={GetMissedCall} title='Get Missed Calls' />
          <Button
            onPress={GetSipRegistrationState}
            title='Get Sip Registration State'
          />
          <Button onPress={GetMicEnable} title='Get Mic Enable' />
          <Button onPress={GetSpeakerEnable} title='Get Speaker Enable' />

          <Section title='Step One'>
            Edit <Text style={styles.highlight}>App.js</Text> to change this
            screen and then come back to see your edits.
          </Section>
          <Section title='See Your Changes'>
            <ReloadInstructions />
          </Section>
          <Section title='Debug'>
            <DebugInstructions />
          </Section>
          <Section title='Learn More'>
            Read the docs to discover what to do next:
          </Section>
          <LearnMoreLinks />
        </View>
      </ScrollView>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
})

export default App
