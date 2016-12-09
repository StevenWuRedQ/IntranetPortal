angular.module("PortalApp").controller("DialerManagementController",
['$scope', 'EmployeeModel', 'ptCom', '$http',
function ($scope, EmployeeModel, ptCom, $http) {
    $scope.lookup = undefined;
    EmployeeModel.getEmpNames().then(
        function success(d) {
            var employeesList = d.data;
            $("#lookup").dxLookup({
                items: employeesList,
                value: employeesList[0],
                showPopupTitle: false
            });
            $scope.lookup = $("#lookup").dxLookup("instance");
        });

    $scope.CreateContactList = function () {
        if ($scope.lookup) {
            var emp = $scope.lookup.option('value');
            if (emp) {
                $http({
                    method: "POST",
                    url: '/api/dialer/CreateContactList/' + emp
                }).then(function (d) {
                    ptCom.alert("Contact For " + emp + " is: " + d.data);
                }, function () {
                    ptCom.alert("Fail to create list, may existing");
                }
                    )
            } else {
                ptCom.alert("Employee not select corretly");
            }
        } else {
            ptCom.alert("Lookup not init yet.")
        }
    }
    $scope.SyncNewLeadsFolder = function () {
        if ($scope.lookup) {
            var emp = $scope.lookup.option("value");
            if (emp) {
                $http({
                    method: 'POST',
                    url: '/api/dialer/SyncNewLeadsFolder/' + emp
                }).then(function sucs(resp) {
                    ptCom.alert("Sync " + resp.data + " leads to new folder");
                }, function err() {
                    ptCom.alert("fail to sync new folder")
                })
            }

        } else {
            ptCom.alert("Lookup not init yet. ")
        }
    }

}])