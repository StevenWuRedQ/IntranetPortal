angular.module("PortalApp").filter('booleanToString', function () {

    return function (v) {
        if (v == undefined) return "N/A"
        else if (v) return "Yes"
        else return "No"
    }
})
