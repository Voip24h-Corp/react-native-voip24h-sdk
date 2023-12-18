//
//  Voip24hSdk.swift
//  Voip24hSdk
//
//  Created by Phát Nguyễn on 08/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

import React
import Foundation
import UIKit

@objc(Voip24hSdk)
class Voip24hSdk: RCTEventEmitter {
    
    lazy private var sipModule: SipModule = {
        return SipModule.getInstance(self)
    }()
    
    @objc
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc
    override func supportedEvents() -> [String]! {
        return ["AccountRegistrationStateChanged", "Ring", "Up", "Hangup", "Paused", "Resuming", "Missed", "Error"]
    }
    
//    @objc(initializeModule)
//    func initializeModule() {
//        sipModule.initializeModule()
//    }
    
    @objc(registerSipAccount:)
    func registerSipAccount(rawData: NSDictionary) {
        do {
            let sipConfiguration = try SipConfiguration(dictionary: rawData as! [String : Any])
            sipModule.registerSipAccount(sipConfiguration: sipConfiguration)
        } catch {
            print(error)
        }
    }
    
    @objc(unregisterSipAccount)
    func unregisterSipAccount() {
        sipModule.unregisterSipAccount()
    }
    
    @objc(refreshRegisterSipAccount)
    func refreshRegisterSipAccount() {
        sipModule.refreshRegisterSipAccount()
    }
    
//    @objc(bluetoothAudio:withRejecter:)
//    func bluetoothAudio(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
//        if let mic = self.bluetoothMic {
//            mCore.inputAudioDevice = mic
//        }
//
//        if let speaker = self.bluetoothSpeaker {
//            mCore.outputAudioDevice = speaker
//        }
//
//        resolve(true)
//    }
    
    @objc(call:)
    func call(recipient: String) {
        sipModule.call(recipient: recipient)
    }
    
    @objc(hangup)
    func hangup() {
        sipModule.hangup()
    }
    
    @objc(decline)
    func decline() {
        sipModule.decline()
    }
    
    @objc(acceptCall)
    func acceptCall() {
        sipModule.acceptCall()
    }
    
    @objc(pause)
    func pause() {
        sipModule.pause()
    }
    
    @objc(resume)
    func resume() {
        sipModule.resume()
    }
    
    @objc(transfer:)
    func transfer(recipient: String) {
        sipModule.transfer(recipient: recipient)
    }
    
//    @objc(loudAudio:withRejecter:)
//    func loudAudio(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
//        if let mic = loudMic {
//            mCore.inputAudioDevice = mic
//        } else if let mic = self.microphone {
//            mCore.inputAudioDevice = mic
//        }
//
//        if let speaker = loudSpeaker {
//            mCore.outputAudioDevice = speaker
//        }
//
//        resolve(true)
//    }
    
//    @objc(micEnabled:withRejecter:)
//    func micEnabled(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
//        resolve(mCore.micEnabled)
//    }
    
//    @objc(phoneAudio:withRejecter:)
//    func phoneAudio(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
//        if let mic = microphone {
//            mCore.inputAudioDevice = mic
//        }
//
//        if let speaker = earpiece {
//            mCore.outputAudioDevice = speaker
//        }
//
//        resolve(true)
//    }
    
//    @objc(scanAudioDevices:withRejecter:)
//    func scanAudioDevices(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
//        microphone = nil
//        earpiece = nil
//        loudSpeaker = nil
//        loudMic = nil
//        bluetoothSpeaker = nil
//        bluetoothMic = nil
//
//        for audioDevice in mCore.audioDevices {
//            switch (audioDevice.type) {
//            case .Microphone:
//                microphone = audioDevice
//            case .Earpiece:
//                earpiece = audioDevice
//            case .Speaker:
//                if (audioDevice.hasCapability(capability: AudioDeviceCapabilities.CapabilityPlay)) {
//                    loudSpeaker = audioDevice
//                } else {
//                    loudMic = audioDevice
//                }
//            case .Bluetooth:
//                if (audioDevice.hasCapability(capability: AudioDeviceCapabilities.CapabilityPlay)) {
//                    bluetoothSpeaker = audioDevice
//                } else {
//                    bluetoothMic = audioDevice
//                }
//            default:
//                NSLog("Audio device not recognised.")
//            }
//        }
//
//        let options: NSDictionary = [
//            "phone": earpiece != nil && microphone != nil,
//            "bluetooth": bluetoothMic != nil || bluetoothSpeaker != nil,
//            "loudspeaker": loudSpeaker != nil
//        ]
//
//        var current = "phone"
//        if (mCore.outputAudioDevice?.type == .Bluetooth || mCore.inputAudioDevice?.type == .Bluetooth) {
//            current = "bluetooth"
//        } else if (mCore.outputAudioDevice?.type == .Speaker) {
//            current = "loudspeaker"
//        }
//
//        let result: NSDictionary = [
//            "current": current,
//            "options": options
//        ]
//        resolve(result)
//    }

    @objc(sendDtmf:)
    func sendDtmf(dtmf: String) {
        sipModule.sendDtmf(dtmf: dtmf)
    }
    
    @objc(toggleMic:withRejecter:)
    func toggleMic(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        sipModule.toggleMic(resolve: resolve, reject: reject)
    }
    
    @objc(toggleSpeaker:withRejecter:)
    func toggleSpeaker(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        sipModule.toggleSpeaker(resolve: resolve, reject: reject)
    }
    
    @objc(getCallId:withRejecter:)
    func getCallId(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        sipModule.getCallId(resolve: resolve, reject: reject)
    }
    
    @objc(getSipRegistrationState:withRejecter:)
    func getSipRegistrationState(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        sipModule.getSipRegistrationState(resolve: resolve, reject: reject)
    }
    
    @objc(getMissedCalls:withRejecter:)
    func getMissedCalls(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        sipModule.getMissedCalls(resolve: resolve, reject: reject)
    }
    
    @objc(isMicEnabled:withRejecter:)
    func isMicEnabled(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock){
        sipModule.isMicEnabled(resolve: resolve, reject: reject)
    }
    
    @objc(isSpeakerEnabled:withRejecter:)
    func isSpeakerEnabled(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        sipModule.isSpeakerEnabled(resolve: resolve, reject: reject)
    }
}

//public enum AudioOutputType: String, CaseIterable {
//    case Unknown = "Unknown"
//    /// Unknown.
//    case Microphone = "Microphone"
//    /// Microphone.
//    case Earpiece = "Earpiece"
//    /// Earpiece.
//    case Speaker = "Speaker"
//    /// Speaker.
//    case Bluetooth = "Bluetooth"
//    /// Bluetooth.
//    case BluetoothA2DP = "BluetoothA2DP"
//    /// Bluetooth A2DP.
//    case Telephony = "Telephony"
//    /// Telephony.
//    case AuxLine = "AuxLine"
//    /// AuxLine.
//    case GenericUsb = "GenericUsb"
//    /// GenericUsb.
//    case Headset = "Headset"
//    /// Headset.
//    case Headphones = "Headphones"
//}
