angular.module("PortalApp")
    .factory('ptHomeBreakDownService', ["$http", function ($http) {
    return {
        loadByBBLE: function (bble, callback) {
            var url = '/ShortSale/ShortSaleServices.svc/LoadHomeBreakData?bble=' + bble;
            $http.get(url)
                .success(function (data) {
                    callback(data);
                }).error(function () {
                    console.log('load home breakdown fail. BBLE: ' + bble);
                });
        },
        save: function (bble, data, callback) {
            var url = '/ShortSale/ShortSaleServices.svc/SaveBreakData';
            var postData = {
                "bble": bble,
                "jsonData": JSON.stringify(data)
            };
            $http.post(url, postData)
                .success(function (res) {
                    callback(res);
                }).error(function () {
                    console.log('save home breakdone fail. BBLE: ' + bble);
                });

        }
    };
}
    ])