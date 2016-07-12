(function () {
    /*define public shared var of class portalRouteProvider register var in the below*/
    var ITEM_ID = 'itemId';

    function portalRouteProvider($routeProvider) {

        // This $get noop is because at the moment in AngularJS "providers" must provide something
        // via a $get method.
        // When AngularJS has "provider helpers" then this will go away!

        /**/
        this.$get = angular.noop;
        this.ITEM_ID = ITEM_ID;
        // Again, if AngularJS had "provider helpers" we might be able to return `routesFor()` as the
        // portalRouteProvider itself.  Then we would have a much cleaner syntax and not have to do stuff
        // like:
        //
        // ```
        // myMod.config(function(portalRouteProvider) {
        //   var routeProvider = portalRouteProvider.routesFor('MyBook', '/myApp');
        // });
        // ```
        //
        // but instead have something like:
        //
        //
        // ```
        // myMod.config(function(portalRouteProvider) {
        //   var routeProvider = portalRouteProvider('MyBook', '/myApp');
        // });
        // ```
        //
        // In any case, the point is that this function is the key part of this "provider helper".
        // We use it to create routes for CRUD operations.  We give it some basic information about
        // the resource and the urls then it it returns our own special routeProvider.
        this.routesFor = function (resourceName, urlPrefix, routePrefix) {
            var baseUrl = resourceName.toLowerCase();

            var baseRoute = '/' + resourceName.toLowerCase();
            routePrefix = routePrefix || urlPrefix;

            // Prepend the urlPrefix if available.
            if (angular.isString(urlPrefix) && urlPrefix !== '') {
                baseUrl = urlPrefix + '/' + baseUrl;
            }

            // Prepend the routePrefix if it was provided;
            if (routePrefix !== null && routePrefix !== undefined && routePrefix !== '') {
                baseRoute = '/' + routePrefix + baseRoute;
            }

            // Create the templateUrl for a route to our resource that does the specified operation.
            var templateUrl = function (operation) {
                return '/js/Views/' + resourceName.toLowerCase() + '/' + resourceName.toLowerCase() + '-' + operation.toLowerCase() + '.tpl.html';
            };
            // Create the controller name for a route to our resource that does the specified operation.
            var controllerName = function (operation) {
                return resourceName + operation + 'Ctrl';
            };

            // This is the object that our `routesFor()` function returns.  It decorates `$routeProvider`,
            // delegating the `when()` and `otherwise()` functions but also exposing some new functions for
            // creating CRUD routes.  Specifically we have `whenList(), `whenNew()` and `whenEdit()`.
            var routeBuilder = {
                // Create a route that will handle showing a list of items
                whenList: function (resolveFns) {
                    routeBuilder.when(baseRoute, {
                        templateUrl: templateUrl('List'),
                        controller: controllerName('List'),
                        resolve: resolveFns
                    });
                    return routeBuilder;
                },
                // Create a route that will handle creating a new item
                whenNew: function (resolveFns) {
                    routeBuilder.when(baseRoute + '/new', {
                        templateUrl: templateUrl('Edit'),
                        controller: controllerName('Edit'),
                        resolve: resolveFns
                    });
                    return routeBuilder;
                },
                // Create a route that will handle editing an existing item
                whenEdit: function (resolveFns) {
                    routeBuilder.when(baseRoute + '/:' + ITEM_ID, {
                        templateUrl: templateUrl('Edit'),
                        controller: controllerName('Edit'),
                        resolve: resolveFns
                    });
                    return routeBuilder;
                },
                whenOther: function (resolveFns, name, suffixUrl) {
                    var _url = suffixUrl ? suffixUrl : '';
                    routeBuilder.when(baseRoute +'/'+ name.toLowerCase() +'/'+ _url, {
                        templateUrl: templateUrl(name),
                        controller: controllerName(name),
                        resolve: resolveFns
                    });
                    return routeBuilder;
                },
                // Readonly views and controllers
                whenView: function (resolveFns) {
                    routeBuilder.when(baseRoute + '/view/:' + ITEM_ID, {
                        templateUrl: templateUrl('View'),
                        controller: controllerName('View'),
                        resolve: resolveFns
                    });
                    return routeBuilder;
                },
                // Pass-through to `$routeProvider.when()`
                when: function (path, route) {
                    $routeProvider.when(path, route);
                    return routeBuilder;
                },
                // Pass-through to `$routeProvider.otherwise()`
                otherwise: function (params) {
                    $routeProvider.otherwise(params);
                    return routeBuilder;
                },
                // Access to the core $routeProvider.
                $routeProvider: $routeProvider
            };
            return routeBuilder;
        };
    }
    // Currently, v1.0.3, AngularJS does not provide annotation style dependencies in providers so,
    // we add our injection dependencies using the $inject form
    portalRouteProvider.$inject = ['$routeProvider'];

    /*define public shared var of class portalRouteProvider*/
    portalRouteProvider.ITEM_ID = ITEM_ID;
    // Create our provider - it would be nice to be able to do something like this instead:
    //
    // ```
    // angular.module('services.portalRouteProvider', [])
    //   .configHelper('portalRouteProvider', ['$routeProvider, portalRouteProvider]);
    // ```
    // Then we could dispense with the $get, the $inject and the closure wrapper around all this.
    angular.module('PortalApp').provider('portalRoute', portalRouteProvider);
})();