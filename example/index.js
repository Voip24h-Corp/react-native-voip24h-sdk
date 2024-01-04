/**
 * @format
 */

import React from 'react';
import { AppRegistry, NativeEventEmitter, Platform } from 'react-native';
import App from './App';
import { name as appName } from './app.json';

import { SipModule, SipConfigurationBuilder, TransportType } from 'react-native-voip24h-sdk'
import messaging from '@react-native-firebase/messaging';
import { NotificationUtils } from './src/utils/NotificationUtils'
import RNCallKeep from 'react-native-callkeep'
import VoipPushNotification from "react-native-voip-push-notification"

if(Platform.OS === 'android') {
    NotificationUtils.observeNotifitionBackgroundForAndroid()
    messaging().setBackgroundMessageHandler(async (remoteMessage) => {
        console.log('Message handled in the background!', remoteMessage);
        let eventEmitter = new NativeEventEmitter(SipModule)
        eventEmitter.addListener('Ring', event => {
            NotificationUtils.displayIncomingCallNotification(event.phone)
        });
        Login()
    })
}

function Login() {
    var sipConfiguration = new SipConfigurationBuilder(
        'extension',
        'password',
        'ip'
    )
        .setPort(port)
        .setTransportType(TransportType.Udp)
        .setKeepAlive(true)
        .build();
    // console.log(sipConfiguration);
    SipModule.registerSipAccount(sipConfiguration);
}

AppRegistry.registerComponent(appName, () => App);