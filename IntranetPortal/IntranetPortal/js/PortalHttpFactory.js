PortalHttp = {
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
    BuildErrorMessage: function (data) {
        if (data) {
            if (data.data) {

                var messageObj = {
                    Message: data.data.Message,
                    status: data.status,
                    statusText: data.statusText,
                    Url: data.config.url,
                    Method: data.config.method,
                }
                console.log(data)
                var urlName = messageObj.Url.toString().replace(/\//g, ' ').replace('api', '');

                return 'Error : ' + messageObj.Message + '(' + urlName + ')';

            }
        }
        return 'Error in Build Message Format is incorrect !';
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
                    if (!config.noIndicator)
                    {
                        self.ShowLoading();
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