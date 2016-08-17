angular.module("PortalApp")
.filter("ByContact", function () {
    return function (movies, contact) {
        var items = {

            out: []
        };
        if ($.isEmptyObject(contact) || contact.Type === null) {
            return movies;
        }
        angular.forEach(movies, function (value, key) {
            if (value.Type === contact.Type) {
                if (contact.CorpName === '' || contact.CorpName === value.CorpName) {
                    items.out.push(value);
                }
            }
        });
        return items.out;
    };
})
.filter('unsafe', ['$sce', function ($sce) { return $sce.trustAsHtml; }])
.filter('booleanToString', function () {

    return function (v) {
        if (v == undefined) return "N/A"
        else if(v) return "Yes"
        else return "No"
    }
})
