    /**
     * @author steven
     * @date 8/11/2016
     * @todo
     *  the pre condition should will in the control which need
     *  be controller and cleared by yes or no selected.
     * 
     * @param {'ngModel'} ) {
        return {
            require
     * @param {function (scope} link
     * @param element
     * @param attrs
     * @param ngModelController) {
                scope.$watch(attrs.preCondition
     * @param function (newVal
     * @param oldVal) {
                    if (!newVal)
                        eval('scope.' + attrs.ngModel + '=null');                  
                }
     * @param true);

            }
        };
    }
     * @returns {type} 
     */
angular.module("PortalApp")
    .directive('preCondition', function () {
        return {
            require: 'ngModel',           
            link: function (scope, element, attrs, ngModelController) {
                scope.$watch(attrs.preCondition, function (newVal, oldVal) {
                    if (!newVal)
                        eval('scope.' + attrs.ngModel + '=null');                  
                }, true);

            }
        };
    })