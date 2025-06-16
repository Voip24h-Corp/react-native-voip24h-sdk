const MethodRequest = {
    POST: 'post',
    GET: 'get',
    PUT: 'put', 
    DELETE: 'delete',
    HEAD: 'head',
    OPTIONS: 'options',
    PATCH: 'patch'
}

const TransportType = {
    Udp: 'Udp',
    Tcp: 'Tcp',
    Tls: 'Tls',
    Dtls: 'Dtls'
}

const ENV = {
    prod: 'prod',
    dev: 'dev'
}

const Codecs = {
    OPUS: 'opus',
    SPEEX: 'speex',
    PCMU: 'PCMU',
    PCMA: 'PCMA',
    GSM: 'GSM',
    G722: 'G722',
    ILBC: 'iLBC',
    ISAC: 'iSAC',
    L16: 'L16'
}

const GraphRoute = {
    // call
    CallLog: 'call/history',
    Record: 'call/recording',
    // customer
    Contact: 'contact',
    AddContact: 'contact',
    UpdateContact: 'contact',
    DeleteContact: 'contact'
}

export { MethodRequest, TransportType, ENV, Codecs, GraphRoute }