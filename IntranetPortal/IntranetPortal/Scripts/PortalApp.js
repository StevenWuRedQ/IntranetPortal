function getNameFirst(name) {
    if (name == null || name.length <= 0) {
        return '';
    }
    return name[0].toUpperCase();
} getNameFirst

Array.prototype.getUnique = function () {
    var u = {}, a = [];
    for (var i = 0, l = this.length; i < l; ++i) {
        if (u.hasOwnProperty(this[i])) {
            continue;
        }
        a.push(this[i]);
        u[this[i]] = 1;
    }
    return a;
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
        if ($.isEmptyObject(contact) || contact.Type == null) {
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
var portalApp = angular.module('PortalApp', [ 'myFilters']);
function Fomart_data_String(json) {
    function ToDateString(match) {

        return new Date(parseInt(match.substr(6))).toISOString();
    }

    return json.replace(/\/Date\((\d+)\)\//gi, ToDateString);
}
function group_func(item) {
    return getNameFirst(item.Name);
}

portalApp.directive('inputMask', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {

            $(el).mask(attrs.inputMask);
            $(el).on('change', function () {
                scope.$eval(attrs.ngModel + "='" + el.val() + "'");
                //scope[attrs.ngModel] = el.val(); //if your expression doesn't contain dot.
            });
        }
    };
});

portalApp.controller('PortalCtrl', function ($scope, $http, $element) {


    $($('[title]')).tooltip({
        placement: 'bottom'
    });
    $scope.popAddgroup = function (Id) {
        $scope.AddGroupId = Id;
        $('#AddGroupPopup').modal();
    }
    $scope.AddGroups = function () {
        $http.post('/CallBackServices.asmx/AddGroups', { gid: $scope.AddGroupId, groupName: $scope.addGroupName, addUser: $('#CurrentUser').val() }).
           success(function (data) {
               $scope.initGroups();
           });
    }
    $scope.ChangeGroups = function (g) {

        $scope.selectType = g.Id == null ? "All Vendors" : g.GroupName;
        if (g.Id == null) {
            g.Id = 0;
        }
        $http.post('/CallBackServices.asmx/GetContactByGroup', { gId: g.Id }).
            success(function (data) {
                $scope.InitDataFunc(data);
            });
    };
    $scope.InitData = function (data) {
        $scope.allContacts = data.slice();
        var gropData = groupBy(data, group_func);
        $scope.showingContacts = gropData;

        return gropData;
    }
    $scope.initGroups = function () {
        $http.post('/CallBackServices.asmx/GetAllGroups', {}).
         success(function (data, status, headers, config) {
             $scope.Groups = data.d;
             
         }).error(function (data, status, headers, config) {


             alert("error get GetAllGroups: " + status + " error :" + data.d);
         });
    }

    $scope.initGroups();
    $scope.InitDataFunc = function (data) {
        var gropData = $scope.InitData(data.d);
        //debugger;
        var allContacts = gropData;
        if (allContacts.length > 0) {
            $scope.currentContact = gropData[0].data[0];
            m_current_contact = $scope.currentContact;

        }
    }
    $http.post('/CallBackServices.asmx/GetContact', { p: '1' }).
        success(function (data, status, headers, config) {

            //debugger;
            $scope.InitDataFunc(data);
            $scope.AllTest = data.d;

        }).error(function (data, status, headers, config) {

            debugger;
            $scope.LogError = data
            alert("error get contacts: " + status + " error :" + data.d);
        });

    $scope.initLenderList = function () {
        $http.post('/CallBackServices.asmx/GetLenderList', {}).success(function (data, status) {
            $scope.lenderList = data.d.getUnique();
        });
    }

    $scope.initLenderList();

    $scope.predicate = "Name";
    $scope.group_text_order = "group_text";
    $scope.addContact = {};
    $scope.selectType = "All Vendors";
    $scope.query = {};
    $scope.addContactFunc = function () {
        var addType = $scope.query.Type;
        if (!$scope.addContact || !$scope.addContact.Name) {
            alert("Please fill vender Name !");
            return;
        }
        if (addType != null) {
            $scope.addContact.Type = addType;


        }
        var addC = $scope.addContact;
        //addC.OfficeNO = $('#txtOffice').val();
        //addC.Cell = $('#txtCell').val();
        //addC.Email = $('#txtEmail').val();

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
            $scope.initLenderList();
            var stop = $(".popup_employee_list_item_active:first").position().top;
            $('#employee_list').scrollTop(stop);
            var a = 10;
            //debugger;
        }).
        error(function (data, status, headers, config) {
            // called asynchronously if an error occurs
            // or server returns response with an error status.
            var message = data&& data.Message ?data.Message :JSON.stringify(data)

            alert("Add contact error " + message);
        });
    }

    $scope.filterContactFunc = function (e, type) {
        //$(e).parent().find("li").removeClass("popup_menu_list_item_active");
        //$(e).addClass("popup_menu_list_item_active");

        var text = angular.element(e.currentTarget).html();
        //debugger;
        if (typeof (type) == 'string') {
            $scope.query = {};
            $scope.selectType = text;
            return true;
        } else {
            $scope.query.Type = type;
        }

        var corpName = type == 4 && text != 'Lenders' ? text : '';
        $scope.query.CorpName = corpName;


        $scope.addContact.CorpName = corpName;

        $scope.selectType = text;
        return true;
    }

    $scope.SaveCurrent = function () {
        
        $http.post("/CallBackServices.asmx/SaveContact", { json: $scope.currentContact }).
        success(function (data, status, headers, config) {
            $scope.initLenderList();
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