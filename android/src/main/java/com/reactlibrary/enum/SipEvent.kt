package com.reactlibrary.enum

enum class SipEvent(val value: String) {
    AccountRegistrationStateChanged("AccountRegistrationStateChanged"),
    Ring("Ring"),
    Up("Up"),
    Paused("Paused"),
    Resuming("Resuming"),
    Missed("Missed"),
    Hangup("Hangup"),
    Error("Error")
}