var portalApp = angular.module('PortalApp', []);

portalApp.controller('PortalCtrl', function ($scope, $http) {
    $scope.hello = "hello";
    $http.post
    
    $http.get('/CallBackSevices.aspx').
        success(function (data, status, headers, config) {
            // this callback will be called asynchronously
            // when the response is available
            $scope.hello = "333333"
            //debugger;
            $scope.allContacts = data;
            var allContacts = $scope.allContacts;
            if (allContacts.length > 0) {
                $scope.currentContact = $scope.allContacts[0]
               
            }
        }).error(function (data, status, headers, config) {
            // called asynchronously if an error occurs
            // or server returns response with an error status.
            alert("error get contacts" + status + "error :" + data);
        });
    
    //$.ajax({
    //    type: "POST",
    //    url: "/CallBackSevices.aspx/GetContact",

    //    contentType: "application/json; charset=utf-8",
    //    dataType: "json",
    //    success: OnSuccess,
    //    failure: function (response) {
    //        debugger
    //        alert(JSON.stringify( response));
    //    },
    //    error: function (response) {
    //        debugger
    //        alert(JSON.stringify(response));
    //    }
    //});
}
);