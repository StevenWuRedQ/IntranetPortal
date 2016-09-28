angular.module("PortalApp").filter('percentage', function ($filter) {

    return function (v) {
        if (v) {
            vf = parseFloat(v);
            return $filter('number')(v * 100.0, 2) + "%";

        }

    }
})
