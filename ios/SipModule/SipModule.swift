//
//  SipModule.swift
//  Voip24hSdk
//
//  Created by Phát Nguyễn on 02/11/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

import Foundation
import linphonesw

class SipModule {
    
    private var eventEmitter: RCTEventEmitter? = nil
    
    private init(event: RCTEventEmitter?) {
        self.eventEmitter = event
        initializeModule()
    }
    
    static let getInstance: (_ eventEmitter: RCTEventEmitter? ) -> SipModule = { eventEmitter in
        return SipModule(event: eventEmitter)
    }
    
    private var mCore: Core!
    private var timeStartStreamingRunning: Int64 = 0
    private var mRegistrationDelegate : CoreDelegate!
    private var isPause: Bool = false
    
//    private var bluetoothMic: AudioDevice?
//    private var bluetoothSpeaker: AudioDevice?
//    private var earpiece: AudioDevice?
//    private var loudMic: AudioDevice?
//    private var loudSpeaker: AudioDevice?
//    private var microphone: AudioDevice?
//    private var isSpeakerEnabled: Bool = false
    
    private func deleteSipAccount() {
        // To completely remove an Account
        if let account = mCore.defaultAccount {
            mCore.removeAccount(account: account)
            
            // To remove all accounts use
            mCore.clearAccounts()
            
            // Same for auth info
            mCore.clearAllAuthInfo()
        }
    }
    
    private func initializeModule() {
        do {
            LoggingService.Instance.logLevel = LogLevel.Debug
            
            try? mCore = Factory.Instance.createCore(configPath: "", factoryConfigPath: "", systemContext: nil)
            mCore.maxCalls = 1
            try? mCore.start()
            
            // Create a Core listener to listen for the callback we need
            // In this case, we want to know about the account registration status
            mRegistrationDelegate = CoreDelegateStub(
                onCallStateChanged: {(
                    core: Core,
                    call: Call,
                    state: Call.State?,
                    message: String
                ) in
                    switch (state) {
                    case .IncomingReceived:
                        // Immediately hang up when we receive a call. There's nothing inherently wrong with this
                        // but we don't need it right now, so better to leave it deactivated.
                        // try! call.terminate()
                        NSLog("IncomingReceived")
                        let ext = core.defaultAccount?.contactAddress?.username ?? ""
                        let phone = call.remoteAddress?.username ?? ""
                        self.eventEmitter?.sendEvent(withName: "Ring", body: ["extension": ext, "phone": phone, "type": CallType.inbound.rawValue])
                    case .OutgoingInit:
                        // First state an outgoing call will go through
                        NSLog("OutgoingInit")
                    case .OutgoingProgress:
                        // First state an outgoing call will go through
                        NSLog("OutgoingProgress")
                        let ext = core.defaultAccount?.contactAddress?.username ?? ""
                        let phone = call.remoteAddress?.username ?? ""
                        self.eventEmitter?.sendEvent(withName: "Ring", body: ["extension": ext, "phone": phone, "type": CallType.outbound.rawValue])
                    case .OutgoingRinging:
                        // Once remote accepts, ringing will commence (180 response)
                        NSLog("OutgoingRinging")
                    case .Connected:
                        NSLog("Connected")
                    case .StreamsRunning:
                        // This state indicates the call is active.
                        // You may reach this state multiple times, for example after a pause/resume
                        // or after the ICE negotiation completes
                        // Wait for the call to be connected before allowing a call update
                        NSLog("StreamsRunning")
                        if(!self.isPause) {
                            self.timeStartStreamingRunning = Int64(Date().timeIntervalSince1970 * 1000)
                        }
                        self.isPause = false
                        let callId = call.callLog?.callId ?? ""
                        self.eventEmitter?.sendEvent(withName: "Up", body: ["callId": callId])
                    case .Paused:
                        NSLog("Paused")
                        self.isPause = true
                        self.eventEmitter?.sendEvent(withName: "Paused", body: nil)
                    case .Resuming:
                        NSLog("Resuming")
                        self.eventEmitter?.sendEvent(withName: "Resuming", body: nil)
                    case .PausedByRemote:
                        NSLog("PausedByRemote")
                    case .Updating:
                        // When we request a call update, for example when toggling video
                        NSLog("Updating")
                    case .UpdatedByRemote:
                        NSLog("UpdatedByRemote")
                    case .Released:
                        if(self.isMissed(callLog: call.callLog)) {
                            NSLog("Missed")
                            let callee = call.remoteAddress?.username ?? ""
                            let totalMissed = core.missedCallsCount
                            self.eventEmitter?.sendEvent(withName: "Missed", body: ["phone": callee, "totalMissed": totalMissed])
                        } else {
                            NSLog("Released")
                        }
                    case .End:
                        NSLog("End")
                        let duration = self.timeStartStreamingRunning == 0 ? 0 : Int64(Date().timeIntervalSince1970 * 1000) - self.timeStartStreamingRunning
                        self.eventEmitter?.sendEvent(withName: "Hangup", body: ["duration": duration])
                        self.timeStartStreamingRunning = 0
                    case .Error:
                        NSLog("Error")
                        self.eventEmitter?.sendEvent(withName: "Error", body: ["message": message])
                    default:
                        NSLog("Nothing")
                    }
                },
//                onAudioDevicesListUpdated: { (core: Core) in
//                    let currentAudioDeviceType = core.currentCall?.outputAudioDevice?.type
//                    if(currentAudioDeviceType != AudioDeviceType.Speaker && currentAudioDeviceType != AudioDeviceType.Earpiece) {
//                        return
//                    }z
//                    let audioOutputType = AudioOutputType.allCases[currentAudioDeviceType!.rawValue].rawValue
//                    self.sendEvent(withName: "AudioDevicesChanged", body: ["audioOutputType": audioOutputType])
//                },
                onAccountRegistrationStateChanged: { (core: Core, account: Account, state: RegistrationState, message: String) in
                    self.eventEmitter?.sendEvent(withName: "AccountRegistrationStateChanged", body: ["registrationState": RegisterSipState.allCases[state.rawValue].rawValue, "message": message])
                }
            )
            mCore.addDelegate(delegate: mRegistrationDelegate)
        }
    }
    
    private func isMissed(callLog: CallLog?) -> Bool {
        return (callLog?.dir == Call.Dir.Incoming && callLog?.status == Call.Status.Missed)
    }
    
    func registerSipAccount(sipConfiguration: SipConfiguration) {
        do {
            let transport = sipConfiguration.toLpTransportType()
            
            // To configure a SIP account, we need an Account object and an AuthInfo object
            // The first one is how to connect to the proxy server, the second one stores the credentials
            
            // The auth info can be created from the Factory as it's only a data class
            // userID is set to null as it's the same as the username in our case
            // ha1 is set to null as we are using the clear text password. Upon first register, the hash will be computed automatically.
            // The realm will be determined automatically from the first register, as well as the algorithm
            let authInfo = try Factory.Instance.createAuthInfo(username: sipConfiguration.ext, userid: "", passwd: sipConfiguration.password, ha1: "", realm: "", domain: sipConfiguration.domain)
            
            // Account object replaces deprecated ProxyConfig object
            // Account object is configured through an AccountParams object that we can obtain from the Core
            let accountParams = try mCore.createAccountParams()
            
            // A SIP account is identified by an identity address that we can construct from the username and domain
            let identity = try Factory.Instance.createAddress(addr: String("sip:\(sipConfiguration.ext)@\(sipConfiguration.domain):\(sipConfiguration.port)"))
            try! accountParams.setIdentityaddress(newValue: identity)
            
            // We also need to configure where the proxy server is located
            let address = try Factory.Instance.createAddress(addr: String("sip:\(sipConfiguration.domain):\(sipConfiguration.port)"))
            
            // We use the Address object to easily set the transport protocol
            try address.setTransport(newValue: transport)
            try accountParams.setServeraddress(newValue: address)
            // And we ensure the account will start the registration process
            accountParams.registerEnabled = true
            
            // Now that our AccountParams is configured, we can create the Account object
            let account = try mCore.createAccount(params: accountParams)
            
            // Now let's add our objects to the Core
            mCore.addAuthInfo(info: authInfo)
            try mCore.addAccount(account: account)
            
            // Also set the newly added account as default
            mCore.defaultAccount = account
            
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func unregisterSipAccount() {
        // Here we will disable the registration of our Account
        NSLog("Try to unregister")
        if let account = mCore.defaultAccount {
            let params = account.params
            let clonedParams = params?.clone()
            clonedParams?.registerEnabled = false
            account.params = clonedParams
            mCore.clearProxyConfig()
            deleteSipAccount()
        }
    }
    
    func refreshRegisterSipAccount() {
        mCore.refreshRegisters()
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
    
    func call(recipient: String) {
        NSLog("Try to call out")
        do {
            // As for everything we need to get the SIP URI of the remote and convert it sto an Address
            let domain: String? = mCore.defaultAccount?.params?.domain
            NSLog("Domain: %@", domain ?? "")
            if (domain == nil) {
                return NSLog("Outgoing call failure: can't create sip uri")
            }
            let sipUri = String("sip:" + recipient + "@" + domain!)
            
            NSLog("Sip URI: %@", sipUri)
            
            let remoteAddress = try Factory.Instance.createAddress(addr: sipUri)
            
            // We also need a CallParams object
            // Create call params expects a Call object for incoming calls, but for outgoing we must use null safely
            let params = try mCore.createCallParams(call: nil)
            
            // We can now configure it
            // Here we ask for no encryption but we could ask for ZRTP/SRTP/DTLS
            params.mediaEncryption = MediaEncryption.None
            // If we wanted to start the call with video directly
            //params.videoEnabled = true
            
            // Finally we start the call
            let _ = mCore.inviteAddressWithParams(addr: remoteAddress, params: params)
            
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func hangup() {
        NSLog("Trying to hang up")
        do {
            
            if (mCore.callsNb == 0) { return }
            
            // If the call state isn't paused, we can get it using core.currentCall
            let coreCall = (mCore.currentCall != nil) ? mCore.currentCall : mCore.calls[0]
            
            if(coreCall == nil) {
                return
            }
            
//            if(coreCall!.state == Call.State.IncomingReceived) {
//                decline()
//                return
//            }
            
            // Terminating a call is quite simple
            if let call = coreCall {
                try call.terminate()
            } else {
                NSLog("No call to terminate")
            }
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func decline() {
        NSLog("Try to decline")
        do {
            try mCore.currentCall?.decline(reason: Reason.Busy)
            NSLog("Reject successful")
        } catch {
            NSLog(error.localizedDescription)
//             reject("Call decline failed", "Call decline failed", error)
        }
    }
    
    func acceptCall() {
        NSLog("Try accept call")
        do {
            try mCore.currentCall?.accept()
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func pause() {
        NSLog("Try to pause")
        do {
            if (mCore.callsNb == 0) { return }
            
            let coreCall = (mCore.currentCall != nil) ? mCore.currentCall : mCore.calls[0]
            
            if let call = coreCall {
                try call.pause()
            } else {
                NSLog("No call to pause")
            }
            
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func resume() {
        NSLog("Try to resume")
        do {
            if (mCore.callsNb == 0) { return }
            
            let coreCall = (mCore.currentCall != nil) ? mCore.currentCall : mCore.calls[0]
            
            if let call = coreCall {
                try call.resume()
            } else {
                NSLog("No to call to resume")
            }
            
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func transfer(recipient: String) {
        NSLog("Try to transfer")
        do {
            if (mCore.callsNb == 0) { return }
            
            let coreCall = (mCore.currentCall != nil) ? mCore.currentCall : mCore.calls[0]
            
            let domain: String? = mCore.defaultAccount?.params?.domain
            NSLog("Domain: %@", domain ?? "")
            if (domain == nil) {
                NSLog("Outgoing call failure: can't create sip uri")
                return
            }
            
            let address = mCore.interpretUrl(url: String("sip:\(recipient)@\(domain!)"))
            NSLog("Address: %@", String("sip:\(recipient)@\(domain!)"))
            if(address == nil) {
                NSLog("Outgoing call failure: can't create sip uri")
                return
            }
            
            if let call = coreCall {
                try call.transferTo(referTo: address!)
            } else {
                NSLog("No call to transfer")
            }
        } catch {
            NSLog(error.localizedDescription)
        }
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

    func sendDtmf(dtmf: String) {
        do {
            try mCore.currentCall?.sendDtmf(dtmf: dtmf.utf8CString[0])
        } catch {
            NSLog("DTMF not recognised", error.localizedDescription)
        }
    }
    
    func toggleMic(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        if(mCore.currentCall == nil) {
            reject("Call ID not found", "Call ID not found", nil)
        } else {
            mCore.micEnabled = !mCore.micEnabled
            resolve(mCore.micEnabled)
        }
    }
    
    func toggleSpeaker(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        if(mCore.currentCall == nil) {
            reject("Call ID not found", "Call ID not found", nil)
        } else {
            let currentAudioDevice = mCore.currentCall?.outputAudioDevice
            let speakerEnabled = currentAudioDevice?.type == AudioDeviceType.Speaker
            
            // We can get a list of all available audio devices using
            // Note that on tablets for example, there may be no Earpiece device
            for audioDevice in mCore.audioDevices {
                
                // For IOS, the Speaker is an exception, Linphone cannot differentiate Input and Output.
                // This means that the default output device, the earpiece, is paired with the default phone microphone.
                // Setting the output audio device to the microphone will redirect the sound to the earpiece.
                if (speakerEnabled && audioDevice.type == AudioDeviceType.Microphone) {
                    mCore.currentCall?.outputAudioDevice = audioDevice
                    resolve(false)
                    // isSpeakerEnabled = false
                    //return
                } else if (!speakerEnabled && audioDevice.type == AudioDeviceType.Speaker) {
                    mCore.currentCall?.outputAudioDevice = audioDevice
                    resolve(true)
                    // isSpeakerEnabled = true
                    //return
                }
                /* If we wanted to route the audio to a bluetooth headset
                 else if (audioDevice.type == AudioDevice.Type.Bluetooth) {
                 core.currentCall?.outputAudioDevice = audioDevice
                 }*/
            }
        }
    }
    
    func getCallId(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        let callId = mCore.currentCall?.callLog?.callId
        if (callId != nil && !callId!.isEmpty) {
            resolve(callId!)
        } else {
            reject("Call ID not found", "Call ID not found", nil)
        }
    }
    
    func getSipRegistrationState(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        let state = mCore.defaultAccount?.state
        if(state != nil) {
            resolve(RegisterSipState.allCases[state!.rawValue].rawValue)
        } else {
            reject("Register state not found", "Register state not found", nil)
        }
    }
    
    func getMissedCalls(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        resolve(mCore.missedCallsCount)
    }
    
    func isMicEnabled(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock){
        resolve(mCore.micEnabled)
    }
    
    func isSpeakerEnabled(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        let currentAudioDevice = mCore.currentCall?.outputAudioDevice
        let speakerEnabled = currentAudioDevice?.type == AudioDeviceType.Speaker
        resolve(speakerEnabled)
    }
}
