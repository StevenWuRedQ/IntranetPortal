angular.module("PortalApp")
    .service('ptShortsSaleService', ['$http', function ($http) {
    this.getShortSaleCase = function (caseId, callback) {
        var url = "/ShortSale/ShortSaleServices.svc/GetCase?caseId=" + caseId;
        $http.get(url)
            .success(function (data) {
                callback(data);
            })
            .error(function (data) {
                console.log("Get Short sale failed CaseId= " + caseId + ", error : " + JSON.stringify(data));
            });
    };
    this.getShortSaleCaseByBBLE = function (bble, callback) {
        var url = "/ShortSale/ShortSaleServices.svc/GetCaseByBBLE?bble=" + bble;
        $http.get(url)
            .success(function (data) {
                callback(data);
            }).error(function () {
                console.log("Get Short Sale By BBLE fails.");
            }
        );

    };
    this.getBuyerTitle = function (bble, callback) {
        var url = "/api/ShortSale/GetBuyerTitle?bble=";
        $http.get(url + bble)
        .then(function succ(res) {
            if (callback) callback(null, res);
        }, function error() {
            if (callback) callback("Fail to get buyer title for bble: " + bble, null);
        });
    };
    }])