import { TransportType } from "../enum_type/EnumType";

class SipConfiguration {
    constructor(ext = "", pass = "", domain = "", port, isKeepAlive, transport) {
        this.extension = ext;
        this.password = pass;
        this.domain = domain;
        this.port = port;
        this.isKeepAlive = isKeepAlive;
        this.transport = transport;
    }
}

export default class SipConfigurationBuilder {

    port: int = 5060;
    transport: TransportType = TransportType.Udp;
    isKeepAlive: bool = false;

    constructor(extension = "", password = "", domain = "") {
        this.extension = extension;
        this.password = password;
        this.domain = domain;
    }

    setPort(port) {
        this.port = port;
        return this;
    }

    setTransportType(transportType) {
        this.transport = transportType;
        return this;
    }

    setKeepAlive(isKeepAlive) {
        this.isKeepAlive = isKeepAlive;
        return this;
    }

    build() {
        var sipConfiguration = new SipConfiguration(
            this.extension, 
            this.password, 
            this.domain, 
            this.port, 
            this.isKeepAlive, 
            this.transport
        );
        return sipConfiguration;
    }
}