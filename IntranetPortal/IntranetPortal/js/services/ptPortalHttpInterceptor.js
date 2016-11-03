angular.module("PortalApp").factory('PortalHttpInterceptor', ['$log', '$q', '$timeout', 'ptCom', function ($log, $q, $timeout, ptCom) {
    $log.debug('$log is here to show you that this is a regular factory with injection');
    var myInterceptor = {
        delayHide: function () {
            $timeout(ptCom.stopLoading, 300);
        },
        BuildAjaxErrorMessage: function (response) {
            var message = "";
            /*Only error handle*/
            if (response.status > 300 || response.status < 200 || response.status == 203) {
                var dataObj = JSON.parse(response.responseText);
                if (dataObj) {
                    var eMssage = dataObj.ExceptionMessage || dataObj.Message || dataObj.message;
                    var messageObj = { Message: eMssage };
                    message = myInterceptor.BuildErrorMessgeStr(messageObj);
                } else {
                    message = JSON.stringify(response)
                }
            }

            return message;
        },
        BuildErrorMessgeStr: function (messageObj) {

            return 'Error : ' + messageObj.Message || 'No Message' + '<br/> <small>(' + messageObj.urlName || 'No additional Info' + ')</small>';
        }, ErrorUrl: function (url) {
            return url.toString().replace(/\//g, ' ').replace('api', '');
        },
        BuildErrorMessage: function (data) {
            var urlName;
            if (data) {
                if (data.data) {
                    var messageObj = {
                        Message: data.data.ExceptionMessage || data.data.Message,
                        status: data.status,
                        statusText: data.statusText,
                        Url: data.config.url,
                        Method: data.config.method,
                    }
                    console.log(data);
                    urlName = messageObj.Url.toString().replace(/\//g, ' ').replace('api', '');

                    return 'Error : ' + messageObj.Message + '<br/> <small>(' + urlName + ')</small>';

                }
            }
            urlName = data.config.url.toString().replace(/\//g, ' ').replace('api', '');
            return 'Get error !' + '<br/> <small>( Status: ' + data.status + ' ' + urlName + ' )</small>';
        },
        request: function (config) {
            /*config some where do not need show indicator like typeahead and get contacts*/
            if (!config.noIndicator) {
                if (config.url.indexOf('template') < 0) {
                    ptCom.startLoading();
                }
                // 
            }
            myInterceptor.noError = config.options && config.options.noError;
            return config;
        },
        responseError: function (rejection) {
            myInterceptor.delayHide();
            if (!myInterceptor.noError) {
                ptCom.alert(myInterceptor.BuildErrorMessage(rejection));
            }
            return $q.reject(rejection);
        },

        requestError: function (rejection) {
            myInterceptor.delayHide();
            myInterceptor.alert(myInterceptor.BuildErrorMessage(rejection));
            return $q.reject(rejection);
        },

        response: function (response) {
            myInterceptor.delayHide();
            return response;
        },

    };

    return myInterceptor;
}]);