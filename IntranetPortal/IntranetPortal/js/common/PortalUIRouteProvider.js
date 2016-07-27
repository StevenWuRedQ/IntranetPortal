/*
 * Portal UI Route will be the main router we use base on UI-router
 * The Portal Route will be Deprecated
 * 
 */


(function () {
    /*define public shared var of class portalUIRouteProvider register var in the below*/
    var ITEM_ID = 'itemId';

    /**
     * @date 7/25/2016 - 7/26/2016  
     * by the way 7/25/2016 have some time box to 
     * monitor Drone make sure finished refresh leads we assgin to
     * about full day
     * 
     * @class
     * This should be my class in every other language 
     * class name should be Name capital frist word.
     * PortalUIRouteProvider
     * I send two days to find this stupid bug.
     * portalUIRouteProvider should be in class use 
     * This should not portalUIRouteProvider
     * but can not use no capital name like this 
     * 
     * @other
     * also can not use model define such as we do before,
     * Because this is special provide 
     */
    function portalUIRouteProvider($stateProvider) {

        // This $get noop is because at the moment in AngularJS "providers" must provide something
        // via a $get method.
        // When AngularJS has "provider helpers" then this will go away!

        /**/
        this.super = $stateProvider;
        this.$get = angular.noop;
        this.ITEM_ID = ITEM_ID;
        // Again, if AngularJS had "provider helpers" we might be able to return `statesFor()` as the
        // portalUIRouteProvider itself.  Then we would have a much cleaner syntax and not have to do stuff
        // like:
        //
        // ```
        // myMod.config(function(portalUIRouteProvider) {
        //   var routeProvider = portalUIRouteProvider.statesFor('MyBook', '/myApp');
        // });
        // ```
        //
        // but instead have something like:
        //
        //
        // ```
        // myMod.config(function(portalUIRouteProvider) {
        //   var routeProvider = portalUIRouteProvider('MyBook', '/myApp');
        // });
        // ```
        //
        // In any case, the point is that this function is the key part of this "provider helper".
        // We use it to create routes for CRUD operations.  We give it some basic information about
        // the resource and the urls then it it returns our own special routeProvider.
        /**
        * @author : Steven Wu
        * @date   : 7/25/2016
        *
        * @summery
        * like {@link #description} 
        * to expain what's different OOP style bewteen to define class,
        * use usually javascrip OOP (such as JQuery) and Agualar OOP 
        *
        * @description
        *  Angular OOP style is different than JQuery OOP style
        *  Jquery don't have $inject and model, 
        *  so it design OOB use Function way like this
        *
        *  ````````````````````````````````````````````
        *  `JQuery Style version under v 1.6
        *  class Base
        *  function Base {}
        *
        *  class 
        *  var Derived = (function (_super) {
        *  _extends(Derived, _super)
        *      
        *  })(Car)
        * 
        *  Derived.prototype = {
        *   //functions define
        *  }
        * 
        * ````````````````````````````````````````````
        * `````````````````````````````````````````````
        *  `JQuery Style version after v 1.6 use AMD model require.
        *  to manage dependency so AMD and tool babel to generate javascript.
        *  so I have suggest 
        *  1. use babel and AMD generate bundle.js
        *  2. use require js manage dependency in the page themselves.
        **/

        /**
         * @description
         * map views and controllers with ui-router
         * @param  {string} resourceName 
         *         main controller name
         *         in view and map it to index view
         * @return {StateBuilder}
         *         $stateProvider build with pre defined function
         *         such as CRUD router
         *         list edit view new
         *         
         */
        this.statesFor = function (resourceName) {
            if (!resourceName) {
                console.error("resourceName must be defined in $stateProvider");
            }
            // Create the stateTemplateUrl for a route to our resource that does the specified operation.
            var stateTemplateUrl = function (statePath) {
                return '/js/Views/' + resourceName.toLowerCase() + '/' + templateFile(statePath) + '.tpl.html';
            };

            var stateUrl = function(statePath)
            {
                /// get root url name with resourceName
                /// other get state path url

                return  '/' +( !statePath ? resourceName : statePath.replace(".","/") );
            }
            /**
             * @summery
             * Use camelCase style to name controller and end with Ctrl
             * @todo 
             *   For best practice Use pascal case is better 
             *   but lodash dosen't support pascal case function
             *   Use camelCase and capitalize can solve this problem.
             * @example test.edit -> testEditCtrl
             **/
            var stateControllerName = function (statePath) {
                return _.camelCase(resourceName + ' ' + (statePath || '') ) + 'Ctrl';
            };

            /**
             * @description
             * 	find template file name 
             * 	if the state for root contorller the default view is index.tpl file
             * 	
             * @param  {string} statePath 
             *         1. sate path @example new list
             *         2. deep path with . to split
             *            @example list.owner list.manager		
             *         
             * @return {string} 
             *         The file template file name to bind view         
             */
            var templateFile = function (statePath) {

                if (!statePath) {
                    return 'index'
                }

                return _.kebabCase(statePath.toLowerCase());
            }
            // This is the object that our `statesFor()` function returns.  It decorates `$stateProvider`,
            // delegating the `when()` and `otherwise()` functions but also exposing some new functions for
            // creating CRUD routes.  Specifically we have `whenList(), `whenNew()` and `whenEdit()`.
            var stateBuilder = {
                // Create a route that will handle showing a list of items
                // When list bind { ControllerName } + 'Ctrl' to view 'js/Views/' + { ControllerName } + '-list-tpl.html'

                /**
                 * @todo 
                 * better create base curd 
                 * @example
                 * 1. stateNew
                 * 2. stateList
                 * 3. .........
                 * And combine it with function
                 * `stateCURD` will imporve develop effects
                 */

                // Pass-through to `$stateProvider.state()`
                state: function (statePath, resolveFns) {
                    $stateProvider.state(resourceName, {
                        url: stateUrl(statePath),
                        templateUrl: stateTemplateUrl(statePath),
                        controller: stateControllerName(statePath),
                        resolve: resolveFns
                    });
                    return stateBuilder;
                },
                // Pass-through to `$stateProvider.otherwise()`
                otherwise: function (params) {
                    $stateProvider.otherwise(params);
                    return stateBuilder;
                },
                // Access to the core $stateProvider.
                $stateProvider: $stateProvider
            };
            /** config for defaunt controller and view index page  **/
            stateBuilder.state(null, null);
            return stateBuilder;

        };
    }


    // Currently, v1.0.3, AngularJS does not provide annotation style dependencies in providers so,
    // we add our injection dependencies using the $inject form
    portalUIRouteProvider.$inject = ['$stateProvider'];

    /*define public shared var of class portalUIRouteProvider*/
    portalUIRouteProvider.ITEM_ID = ITEM_ID;
    // Create our provider - it would be nice to be able to do something like this instead:
    //
    // ```
    // angular.module('services.portalUIRouteProvider', [])
    //   .configHelper('portalUIRouteProvider', ['$stateProvider, portalUIRouteProvider]);
    // ```
    // Then we could dispense with the $get, the $inject and the closure wrapper around all this.
    angular.module('PortalApp').provider('portalUIRoute', portalUIRouteProvider);
})();