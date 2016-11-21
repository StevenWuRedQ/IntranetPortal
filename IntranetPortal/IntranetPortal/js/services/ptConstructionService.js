angular.module("PortalApp").service('ptConstructionService', ['$http', function ($http) {
    this.getConstructionCases = function (bble, callback) {
        var url = "/api/ConstructionCases/" + bble;
        $http.get(url)
            .success(function (data) {
                if (callback) callback(data);
            }).error(function (data) {
                console.log("Get Construction Data fails.");
            });
    };
    this.saveConstructionCases = function (bble, data, callback) {
        if (bble && data) {
            bble = bble.trim();
            var url = "/api/ConstructionCases/" + bble;
            $http.put(url, data)
                .success(function (res) {
                    if (callback) callback(res);
                }).error(function () {
                    alert('Save CSCase fails.');
                });
        }
    };
    this.getDOBViolations = function (bble, callback) {
        if (bble) {
            var url = "/api/ConstructionCases/GetDOBViolations?bble=" + bble;
            $http.get(url)
            .success(function (res) {
                if (callback) callback(null, res);
            }).error(function () {
                if (callback) callback("load dob violations fails");
            });
        } else {
            if (callback) callback("bble is missing");
        }
    };
    this.getECBViolations = function (bble, callback) {
        if (bble) {
            var url = "/api/ConstructionCases/GetECBViolations?bble=" + bble;
            $http.get(url)
            .success(function (res) {
                if (callback) callback(null, res);
            }).error(function () {
                if (callback) callback("load ecb violations fails");
            });
        }
    };
}
])