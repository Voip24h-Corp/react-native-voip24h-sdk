package com.reactlibrary.push_module

//import android.util.Log
//import com.facebook.react.bridge.ReactApplicationContext
//import com.google.firebase.messaging.FirebaseMessagingService
//import com.google.firebase.messaging.RemoteMessage
//import com.reactlibrary.sip_module.SipModule
//
//class PushKitService : FirebaseMessagingService() {
//
//    private val sipModule by lazy { SipModule.newInstance(this.applicationContext as ReactApplicationContext) }
//
//    override fun onNewToken(token: String) {
//        super.onNewToken(token)
//        //sipModule.setToken(token)
//    }
//
//    override fun onMessageReceived(message: RemoteMessage) {
//        super.onMessageReceived(message)
//        Log.d(TAG, message.toString())
//    }
//
//    companion object {
//        private val TAG = PushKitService::class.java.name
//    }
//}