import { MethodRequest, ENV } from './enum_type/EnumType';
import axios from 'axios';

const URL = {
    API_PUSH: "http://14.225.251.99:1998",
    REGISTER_PUSH: "http://14.225.251.99:1998/register_push_for_sdk",
    UNREGISTER_PUSH: "http://14.225.251.99:1998/unregister_push_for_sdk"
}

const PushNotificationModule = {
    registerPushNotification: function(token, tokenDevice, sipConfiguration, platform, packageId, isProduction, deviceMac) {
        return new Promise((resolve, reject) => {
            let env = ENV.prod
            if(!isProduction) {
                env = ENV.dev
            }
            let params = {
                "pbx_ip": sipConfiguration.domain,
                "extension": sipConfiguration.extension,
                "device_os": platform,
                "device_mac": deviceMac,
                "voip_token": tokenDevice,
                "env": env,
                "app_id": packageId,
                "is_new": true,
                "is_active": true,
                "transport": "udp"
            }
            axios({
                method: MethodRequest.POST,
                url: URL.REGISTER_PUSH,
                data: params,
                headers: { Authorization: `Bearer ${token}` },
            })
            .then(response => {
                resolve(response)
            })
            .catch(error => {
                reject(error)
            });  
        })
    },

    unregisterPushNotification: function(sipConfiguration, platform, packageId) {
        return new Promise((resolve, reject) => {
            let params = {
                "pbx_ip": sipConfiguration.domain,
                "extension": sipConfiguration.extension,
                "device_os": platform,
                "app_id": packageId
            }
            axios({
                method: MethodRequest.POST,
                url: URL.UNREGISTER_PUSH,
                data: params
            })
            .then(response => {
                resolve(response)
            })
            .catch(error => {
                reject(error)
            })    
        })
    }
}

export default PushNotificationModule;