function getNameFirst(name) {
    if (name.length <= 0) {
        return '';
    }
    return name[0].toUpperCase();
}

function groupBy(array, f) {
    var groups = {};
    array.forEach(function (o) {
        var group = JSON.stringify(f(o));
        
        groups[group] = groups[group] || [];
        groups[group].push(o);
    });
    
    
    return Object.keys(groups).map(function (group) {
        var gropObj = {}
        gropObj.group_text = group.replace(/\"/gi, "");
        gropObj.data = groups[group]
        return gropObj;
    })
    return groups;
   
}


var portalApp = angular.module('PortalApp', []);
function Fomart_data_String(json)
{
    function ToDateString(match) {
       
        return new Date(parseInt(match.substr(6))).toISOString();
    }
   
    return json.replace(/\/Date\((\d+)\)\//gi, ToDateString)
}

portalApp.controller('PortalCtrl', function ($scope, $http) {



    $http.get('/CallBackSevices.aspx').
        success(function (data, status, headers, config) {
            // this callback will be called asynchronously
            // when the response is available
            //debugger;
            var gropData = groupBy(data, function (item) { return getNameFirst(item.Name); })
            

            $scope.allContacts = gropData;
            var allContacts = $scope.allContacts;
            if (allContacts.length > 0) {
                $scope.currentContact = $scope.allContacts[0].data[0]
                $scope.showingContacts = $scope.allContacts
            }
        }).error(function (data, status, headers, config) {
            // called asynchronously if an error occurs
            // or server returns response with an error status.
            alert("error get contacts: " + status + " error :" + data);
        });
    $scope.predicate = "Name"
    $scope.group_text_order = "group_text"
    $scope.SaveCurrent = function () {
        $http.post('/CallBackSevices.aspx/SaveContact', { json: JSON.stringify($scope.currentContact) }).
        success(function (data, status, headers, config) {
            // this callback will be called asynchronously
            // when the response is available
        }).
        error(function (data, status, headers, config) {
            // called asynchronously if an error occurs
            // or server returns response with an error status.
            debugger
            alert("geting SaveCurrent error" + status + "error:" + data);
        });
    }

    $scope.FilterContact = function (type) {
        $scope.showingContacts = $scope.allContacts;
        if (type < 0) {
            return;
        }
        //debugger
        //$filter('filter')($scope.showingContacts, { Type: 0 });
        //var phoneList = element.all(by.repeater('contact in showingContacts'));
        //var query = element(by.model('query'));
        //expect(phoneList.count()).toBe(3);

        //$scope.showingContacts = [];
        var contacts = $scope.allContacts;

        for (var i = 0; i < contacts.length; i++) {
            if (contacts.Type != type) {
                $scope.showingContacts.splice(i, 1);
            }

        }

    }
    $scope.selectCurrent = function (selectContact) {
        $scope.currentContact = selectContact;
    }
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