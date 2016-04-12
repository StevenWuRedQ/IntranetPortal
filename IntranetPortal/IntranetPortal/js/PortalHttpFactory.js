﻿PortalHttp = {
    requestCount: 0,
    ShowLoading: function () {
        if (!AngularRoot) {

            //console.error("PortalHttp ShowLoading AngularRoot not init yet Portal Http dependent it please run init after AngularRoot init!");
            return;
        }

        AngularRoot.showLoading();
    },
    HideLoading: function () {
        if (!AngularRoot) {
            //console.error("PortalHttp ShowLoading AngularRoot not init yet Portal Http dependent it please run init after AngularRoot init!");
            return;
        }
        // delay 0.3 to close second for the http request too fast.
        setTimeout(function () {
            AngularRoot.hideLoading();
        }, 300);
        
    },
    Alert: function (message) {
        if (!AngularRoot) {
            console.error("PortalHttp ShowLoading AngularRoot not init yet Portal Http dependent it please run init after AngularRoot init!");
            return;
        }
        AngularRoot.alert(message);
    },
    /*
     *Build Ajax error usually using in sync ajax call from Jquery 
     *return empty when the request sucessed.
     */
    BuildAjaxErrorMessage:function(response)
    {
        var message = "";
        if (response.status!=200)
        {
            var dataObj = JSON.parse(response.responseText);
            if (dataObj && dataObj.ExceptionMessage) {
                message = dataObj.ExceptionMessage;
            }else
            {
                message = JSON.stringify(response)
            }
        }
        
        return message;
    },
    BuildErrorMessage: function (data) {
        if (data) {
            if (data.data) {

                var messageObj = {
                    Message: data.data.ExceptionMessage || data.data.Message,
                    status: data.status,
                    statusText: data.statusText,
                    Url: data.config.url,
                    Method: data.config.method,
                }
                console.log(data)
                var urlName = messageObj.Url.toString().replace(/\//g, ' ').replace('api', '');

                return 'Error : ' + messageObj.Message + '<br/> <small>(' + urlName + ')</small>';

            }
        }
        var urlName = data.config.url.toString().replace(/\//g, ' ').replace('api', '');
        return 'Get error !' + '<br/> <small>( Status: ' + data.status +' '+ urlName + ' )</small>';
    },
    init: function () {
        var self = this;
        if (!portalApp) {
            console.error("Can not find portalApp in page please import intranet portal and angler js and app first !")
            return;
        }

        portalApp.factory('PortalHttpInterceptor', ['$log', '$q', function ($log, $q) {
            $log.debug('$log is here to show you that this is a regular factory with injection');

            var myInterceptor = {
                'request': function (config) {
                    /*config some where do not need show indicator like typeahead and get contacts*/
                    if (!config.noIndicator )
                    {
                        if (config.url.indexOf('template') < 0)
                        {
                            self.ShowLoading();
                        }
                       
                    }
                    return config;
                },
                'requestError': function (rejection) {

                    self.HideLoading();
                    self.Alert(self.BuildErrorMessage(rejection));
                    return $q.reject(rejection);
                },

                // optional method
                'response': function (response) {
                    // do something on success
                    //alert("response")
                    self.HideLoading();
                    return response;
                },

                // optional method
                'responseError': function (rejection) {
                    // do something on error
                    //alert("responseError");
                    self.HideLoading();
                    self.Alert(self.BuildErrorMessage(rejection));
                    return $q.reject(rejection);
                }
            };

            return myInterceptor;
        }]);
        portalApp.config(['$httpProvider', function ($httpProvider) {
            $httpProvider.interceptors.push('PortalHttpInterceptor');
        }]);
    }
}
PortalHttp.init();