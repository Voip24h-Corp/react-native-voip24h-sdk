import axios from 'axios';
import type  { AccessTokenEventCallback, RequestEventCallback } from './callback/GraphEventCallback';
import OAuth from './model/OAuth';
import { URL } from './utils/Constant';

const GraphModule = {
    getAccessToken: function(
        apiKey: string, 
        apiSecert: string, 
        callback: AccessTokenEventCallback
    ) {
        axios.post(URL.GRAPH_TOKEN, {
            api_key: apiKey,
            api_secert: apiSecert
        })
        .then(response => {
            var responseObj = response.data;
            if(responseObj.data.response.data !== null) {
                var responseData = responseObj.data.response;
                var oauth = new OAuth(responseData.data.IsToken, responseData.data.Createat, responseData.data.Expried, responseData.data.IsLonglive);
                callback.success(responseData.status, responseData.message, oauth);
                return
            }
            callback.error(responseObj.data.response.status, responseObj.data.response.message);
        })
        .catch(error => {
            callback.error(error.response.status, error.message);
        });
    },

    sendRequest: function(
        method: string, 
        endpoint: string, 
        token: string,
        params: object,
        callback: RequestEventCallback
    ) {
        axios({
            method: method,
            url: URL.GRAPH + endpoint,
            headers: { Authorization: `Bearer ${token}` },
            data: params
        })
        .then(response => {
            var responseObj = response.data;
            if(responseObj.data.response.data !== null) {
                var responseData = responseObj.data.response;
                if(responseData.data.data !== undefined) { // case: json media record
                    callback.success(responseData.status, responseData.message, responseData.data.data);
                    return
                }
                callback.success(responseData.status, responseData.message, responseData.data);
                return
            }
            callback.error(responseObj.data.response.status, responseObj.data.response.message);
        })
        .catch(error => {
            console.log(error);
            callback.error(error.response.status, error.message);
        });
    },

    getData: function(jsonObject: object) {
        var data = Object.assign({}, jsonObject);
        return data;
    },

    getListData: function(jsonObject: object) {
        var dataList = Object.assign([], jsonObject);
        return dataList;
    }
}

export default GraphModule;