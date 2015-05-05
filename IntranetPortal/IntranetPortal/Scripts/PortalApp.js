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


    return Object.keys(groups).map(function(group) {
        var gropObj = {}
        gropObj.group_text = group.replace(/\"/gi, "");
        gropObj.data = groups[group];
        return gropObj;
    });
    return groups;

}
var m_current_contact = null;


angular.module('myFilters', []).
filter('ByContact', function () {
    return function (movies, contact) {
        var items = {

            out: []
        };
        if ($.isEmptyObject(contact)) {
            return movies;
        }
        angular.forEach(movies, function (value, key) {
            
            if (value.Type == contact.Type) {
                if (contact.CorpName == '' || contact.CorpName == value.CorpName) {
                    items.out.push(value);
                }
            }
        });
        return items.out;
    };
});
var portalApp = angular.module('PortalApp', ['ngMaterial', 'myFilters']);
function Fomart_data_String(json) {
    function ToDateString(match) {

        return new Date(parseInt(match.substr(6))).toISOString();
    }

    return json.replace(/\/Date\((\d+)\)\//gi, ToDateString)
}
function group_func(item) {
    return getNameFirst(item.Name);
}
portalApp.controller('PortalCtrl', function ($scope, $http, $element) {
    $($('[title]')).tooltip({
        placement: 'bottom'
    });
    $scope.InitData = function (data) {
        $scope.allContacts = data.slice();
        var gropData = groupBy(data, group_func);
        $scope.showingContacts = gropData;

        return gropData;
    }

    $http.post('/CallBackServices.asmx/GetContact', { p: '' }).
        success(function (data, status, headers, config) {

            //debugger;

            var gropData = $scope.InitData(data.d);
            //debugger;
            var allContacts = gropData;
            if (allContacts.length > 0) {
                $scope.currentContact = gropData[0].data[0];
                m_current_contact = $scope.currentContact;

            }

        }).error(function (data, status, headers, config) {

            debugger;
            alert("error get contacts: " + status + " error :" + data.d);
        });

    $http.post('/CallBackServices.asmx/GetLenderList', {}).success(function (data, status) {
        $scope.lenderList = data.d;
    });

    $scope.predicate = "Name";
    $scope.group_text_order = "group_text";
    $scope.addContact = {};
    $scope.selectType = "All Vendors";
    $scope.query = {};
    $scope.addContactFunc = function () {
        var addType = $scope.query.Type;
        if (addType != null) {
            $scope.addContact.Type = addType;


        }
        var addC = $scope.addContact;
        addC.OfficeNO = $('#txtOffice').val();
        addC.Cell = $('#txtCell').val();
        addC.Email = $('#txtEmail').val();

        debugger;
        $http.post("/CallBackServices.asmx/AddContact", { contact: $scope.addContact }).
        success(function (data, status, headers, config) {
            // this callback will be called asynchronously
            // when the response is available
            $scope.allContacts.push(data.d);
            $scope.InitData($scope.allContacts);
            var addContact = data.d;
            //debugger;

            $scope.currentContact = addContact;
            m_current_contact = $scope.currentContact;
            //debugger;
        }).
        error(function (data, status, headers, config) {
            // called asynchronously if an error occurs
            // or server returns response with an error status.
            debugger;
            alert("geting addContactFunc error" + status + "error:" + data);
        });
    }

    $scope.filterContactFunc = function (e, type) {
        //$(e).parent().find("li").removeClass("popup_menu_list_item_active");
        //$(e).addClass("popup_menu_list_item_active");

        var text = angular.element(e.currentTarget).html();
        //debugger;
        if (typeof(type) == 'string') {
            $scope.query = {};
            $scope.selectType = text;
            return true;
        } else {
            $scope.query.Type = type;
        }
       

        $scope.query.CorpName = type == 4 && text != 'Lenders' ? text : '';

        $scope.selectType = text;
        return true;
    }
    $scope.SaveCurrent = function () {

        $http.post("/CallBackServices.asmx/SaveContact", { json: $scope.currentContact }).
        success(function (data, status, headers, config) {

        }).
        error(function (data, status, headers, config) {
            alert("geting SaveCurrent error" + status + "error:" + JSON.stringify(data.d));
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
        m_current_contact = selectContact;
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