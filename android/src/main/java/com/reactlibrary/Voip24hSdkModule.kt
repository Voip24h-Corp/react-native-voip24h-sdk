// Voip24hSdkModule.java
package com.reactlibrary

import android.util.Log
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.google.gson.Gson
import com.reactlibrary.models.SipConfiguration
import com.reactlibrary.sip_module.SipModule

class Voip24hSdkModule(private val reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {

    private val sipModule by lazy { SipModule.newInstance(reactContext) }

    companion object {
        private const val TAG = "Voip24hSdkModule"
        private const val NAME_MODULE = "Voip24hSdk"
    }

    override fun getName(): String = NAME_MODULE

//    @ReactMethod
//    fun initializeModule() = sipModule.initializeModule(reactContext)

    @ReactMethod
    fun registerSipAccount(data: ReadableMap) {
        try {
            val sipConfiguration = Gson().fromJson(data.toHashMap().toString(), SipConfiguration::class.java)
            Log.d(TAG, sipConfiguration.toString())
            sipModule.registerSipAccount(sipConfiguration)
        } catch (e: Exception) {
            Log.e(TAG, e.message.toString())
        }
    }

    @ReactMethod
    fun refreshRegisterSipAccount() = sipModule.refreshRegisterSipAccount()

    @ReactMethod
    fun unregisterSipAccount() = sipModule.unregisterSipAccount()

    @ReactMethod
    fun call(recipient: String) = sipModule.call(recipient)

    @ReactMethod
    fun hangup() = sipModule.hangup()

    @ReactMethod
    fun acceptCall() = sipModule.acceptCall()

    @ReactMethod
    fun decline() = sipModule.decline()

    @ReactMethod
    fun pause() = sipModule.pause()

    @ReactMethod
    fun resume() = sipModule.resume()

    @ReactMethod
    fun transfer(recipient: String) = sipModule.transfer(recipient)

    @ReactMethod
    fun sendDtmf(dtmf: String) = sipModule.sendDtmf(dtmf)

    @ReactMethod
    fun toggleMic(promise: Promise) = sipModule.toggleMic(promise)

    @ReactMethod
    fun toggleSpeaker(promise: Promise) = sipModule.toggleSpeaker(promise)

    @ReactMethod
    fun getCallId(promise: Promise) = sipModule.getCallId(promise)

    @ReactMethod
    fun getMissedCalls(promise: Promise) = sipModule.getMissedCalls(promise)

    @ReactMethod
    fun getSipRegistrationState(promise: Promise) = sipModule.getSipRegistrationState(promise)

    @ReactMethod
    fun isMicEnabled(promise: Promise) = sipModule.isMicEnabled(promise)

    @ReactMethod
    fun isSpeakerEnabled(promise: Promise) = sipModule.isSpeakerEnabled(promise)

    @ReactMethod
    fun addListener(eventName: String?) {
    }

    @ReactMethod
    fun removeListeners(count: Int?) {
    }
}