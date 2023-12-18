//
//  SipConfiguration.swift
//  Voip24hSdk
//
//  Created by Phát Nguyễn on 27/11/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import linphonesw

struct SipConfiguration: Codable {
    var ext: String = ""
    var password: String = ""
    var domain: String = ""
    var port: Int = 5060
    var transport: String = ""
    var isKeepAlive: Bool = false
    
    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(SipConfiguration.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
    
    private enum CodingKeys: String, CodingKey {
        case ext = "extension"
        case password, domain, port, transport, isKeepAlive
    }
    
    func toLpTransportType() -> TransportType {
        switch(transport) {
            case "Udp":
                return TransportType.Udp
            case "Tcp":
                return TransportType.Tcp
            case "Tls":
                return TransportType.Tls
            case "Dtls":
                return TransportType.Dtls
            default:
                return TransportType.Udp
        }
    }
}
