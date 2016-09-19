/**
 * *********************************************************
 * @author Steven
 * @date 8/11/2016
 * 
 * sent time to write this initGrid to fix the save bug 
 * and init data bug
 *
 * @returns directive init Grid
 * 
 * 
 * @*********************************************************
 * @author Steven
 * @datetime 8/12/2016 2:54
 * @bug
 *  When switch to other cases the grid dataSource is empty
 *  It can not add new rows
 *  
 * @fix Steven
 * @end datetime 
 * @*********************************************************
 */
angular.module("PortalApp")
    .directive('initGrid', ['$parse', function ($parse) {
        return {
            link: function (scope, element, attrs, ngModelController) {
                var gridOptions = null;
                eval("gridOptions =" + attrs.dxDataGrid);
                if (gridOptions) {
                    var option = gridOptions.bindingOptions.dataSource;
                    var array = scope.$eval(option);

                    if (array == null || array == undefined)
                        eval('scope.' + option + '=[];');

                    scope.$watch(attrs.initGrid, function (newValue) {
                        var array = scope.$eval(option);
                        if (array == null || array == undefined)
                            eval('scope.' + option + '=[];');
                        // scope.$eval(option + '=[];');
                    });
                }
            }
        };
    }]);