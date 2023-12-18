package com.reactlibrary.models

data class SipConfiguration(
    var extension: String = "",
    var password: String = "",
    var domain: String = "",
    var port: Int = 5060,
    var transport: String = "",
    var isKeepAlive: Boolean = false
)