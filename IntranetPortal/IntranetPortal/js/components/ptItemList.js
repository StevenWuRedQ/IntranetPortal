angular.module('PortalApp').component('ptItemList', {

    templateUrl: '/js/components/ptItemList.html',
    bindings: {
        itemName: '@',
        itemUrl: '@',
        itemField: '@',
        onSelectionChanged: '&'
    },
    controller: function ($scope, $element, $attrs, $http) {
        $scope.list = {}
        $scope.searchOptions = {
            valueChangeEvent: "keyup",
            placeholder: "Search",
            mode: "search",
            onValueChanged: function (args) {
                $scope.list.searchValue(args.value);
                $scope.list.load();
            }
        };
        $scope.listOptions = {
            selectionMode: "single",
            onSelectionChanged: function (data) {
                $scope.$ctrl.onSelectionChanged(data);
            },
            columns: [
                {
                    dataField: $scope.$ctrl.itemField,
                    itemTemplate: function (data, index) {
                        var result = $("<div>").addClass("list-item");
                        $("<div>").text(data[$scope.$ctrl.itemField]).css("padding-left", "10px").appendTo(result);
                        return result;
                    }
                }
            ],

            bindingOptions: {
                dataSource: 'list',
            }

        }
        $scope.bindList = function () {
            //debugger;
            $http({
                method: 'GET',
                url: $scope.$ctrl.itemUrl
            }).then(function(d) {
                $scope.list = new DevExpress.data.DataSource({
                    searchOperation: "contains",
                    searchExpr: $scope.$ctrl.itemField,
                    store: d.data
                });
            });
        }

        $scope.bindList();


    }

})