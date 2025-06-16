import axios from 'axios';
import OAuth from './model/OAuth';

const URL = {
    GRAPH: "https://api.voip24h.vn/v3/", // http://graph.voip24h.vn/
    GRAPH_TOKEN: "https://api.voip24h.vn/v3/authentication/" // http://auth2.voip24h.vn/api/token
}

const GraphModule = {
    getAccessToken: function(apiKey, apiSecret, isLongLive, callback) {
        axios.post(URL.GRAPH_TOKEN, { apiKey, apiSecret, isLongLive })
        .then(response => {
            var responseObj = response.data;
            // console.log("getAccessToken response: ", responseObj.message)
            if(responseObj.data !== null) {
                var responseData = responseObj.data;
                var oauth = new OAuth(responseData.token, responseData.createAt, responseData.expired, responseData.isLongLive);
                callback.success(responseData.status, responseData.message, oauth);
                return
            }
            callback.error(responseObj.status, responseObj.message);
        })
        .catch(error => {
            callback.error(error.response.status, error.message);
        });
    },

    sendRequest: function(method, endpoint, token, params, callback) {
        const config = {
            method: method,
            url: URL.GRAPH + endpoint,
            headers: { Authorization: `Bearer ${token}` }
        }
        if (config.method === 'get') {
            config.params = params
        } else {
            config.data = params
        }
        axios(config)
        .then(response => {
            var responseObj = response.data;
            // console.log("sendRequest response: ", responseObj)
            if(responseObj.data !== null) {
                // var responseData = responseObj.data
                // if(responseData.data !== undefined) { // case: json media record
                //     callback.success(responseData.status, responseData.message, responseData.data.data);
                //     return
                // }
                // console.log("sendRequest response data: ", responseData)
                callback.success(responseObj.status, responseObj.message, responseObj)
                return
            }
            callback.error(responseObj.status, responseObj.message);
        })
        .catch(error => {
            console.log(error);
            callback.error(error.response.status, error.message);
        });
    },
    // getData: function(jsonObject) {
    //     var data = Object.assign({}, jsonObject);
    //     return data;
    // },

    // getListData: function(jsonObject) {
    //     var dataList = Object.assign([], jsonObject);
    //     return dataList;
    // }
}

export default GraphModule;