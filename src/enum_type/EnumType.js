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

export { MethodRequest, TransportType, ENV }