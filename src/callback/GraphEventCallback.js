const AccessTokenEventCallback = {
    success: (statusCode, message, oauth) => {},
    error: (statusCode, message) => {}
}

const RequestEventCallback = {
    success: (statusCode, message, jsonObject) => {},
    error: (statusCode, message) => {}
}

module.exports = {
    AccessTokenEventCallback,
    RequestEventCallback
}