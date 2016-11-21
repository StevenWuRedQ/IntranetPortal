angular.module("PortalApp")
    .service('ptLeadsService', ["$http", function ($http) {
    this.getLeadsByBBLE = function (bble, callback) {
        var leadsInfoUrl = "/ShortSale/ShortSaleServices.svc/GetLeadsInfo?bble=" + bble;
        $http.get(leadsInfoUrl)
        .success(function (data) {
            callback(data);
        }).error(function (data) {
            console.log("Get Short sale Leads failed BBLE =" + bble + " error : " + JSON.stringify(data));
        });
    };
}
    ])