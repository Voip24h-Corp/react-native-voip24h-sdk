/**
 * @format
 */

import React from 'react';
import { AppRegistry, NativeEventEmitter, Platform } from 'react-native';
import App from './App';
import { name as appName } from './app.json';

import { CallModule, SipConfigurationBuilder, TransportType } from 'react-native-voip24h-sdk'
import messaging from '@react-native-firebase/messaging';
import { NotificationUtils } from './src/utils/NotificationUtils'

if(Platform.OS === 'android') {
    NotificationUtils.observeNotifitionBackgroundForAndroid()
    messaging().setBackgroundMessageHandler(async (remoteMessage) => {
        console.log('Message handled in the background!', remoteMessage);
        let eventEmitter = new NativeEventEmitter(CallModule)
        eventEmitter.addListener('Ring', event => {
            NotificationUtils.displayIncomingCallNotification(event.phone)
        });
        Login()
    })
}

function Login() {
    var sipConfiguration = new SipConfigurationBuilder(
        "844",
        "844@&#@28082023-remove",
        "203.162.56.226"
    )
        .setPort(5060)
        .setTransportType(TransportType.Udp)
        .setKeepAlive(true)
        .build();
    // console.log(sipConfiguration);
    CallModule.registerSipAccount(sipConfiguration);
}

AppRegistry.registerComponent(appName, () => App);