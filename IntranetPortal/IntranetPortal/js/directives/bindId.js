// a directive to bind contact with it's contact it
angular.module("PortalApp")
    .directive('bindId', ['ptContactServices', function (ptContactServices) {
        return {
            restrict: 'A',
            link: function postLink(scope, el, attrs) {
                scope.$watch(attrs.bindId, function (newValue, oldValue) {
                    if (newValue !== oldValue) {
                        var contact = ptContactServices.getContactById(newValue);
                        if (contact) scope.$eval(attrs.ngModel + "='" + contact.Name + "'");
                    }
                });
            }

        }
    }])