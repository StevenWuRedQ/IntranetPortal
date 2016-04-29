angular.module("PortalApp")
.controller('BuyerEntityCtrl', ['$scope', '$http', 'ptContactServices', function ($scope, $http, ptContactServices) {
    $scope.EmailTo = [];
    $scope.EmailCC = [];
    $scope.ptContactServices = ptContactServices;
    $scope.selectType = 'All Entities';
    $scope.loadPanelVisible = true;
    //for view and upload document -- add by chris
    $scope.encodeURIComponent = window.encodeURIComponent;
    $http.get('/Services/ContactService.svc/GetAllBuyerEntities')
        .success(function (data) {
            $scope.CorpEntites = data;
            $scope.currentContact = $scope.CorpEntites[0];
            $scope.loadPanelVisible = false;
        }).error(function (data) {
            alert('Get All buyers Entities error : ' + JSON.stringify(data));
        });
    $http.get('/Services/TeamService.svc/GetAllTeam')
        .success(function (data) {
            $scope.AllTeam = data;
        }).error(function (data) {
            alert('Get All Team name  error : ' + JSON.stringify(data));
        });
    $scope.Groups = [
        { GroupName: 'All Entities' },
        { GroupName: 'Available' },
        { GroupName: 'Assigned Out' },
        {
            GroupName: 'Current Offer',
            SubGroups:
            [
                { GroupName: 'NHA Current Offer' }, { GroupName: 'Isabel Current Offer' },
                { GroupName: 'Quiet Title Action' }, { GroupName: 'Deed Purchase' },
                { GroupName: 'Straight Sale' }, { GroupName: 'Jay Current Offer' }
            ]
        },
        {
            GroupName: 'Sold',
            SubGroups: [
                { GroupName: 'Purchased' }, { GroupName: 'Partnered' },
                { GroupName: 'Sold (Final Sale)/Recyclable' }
            ]
        },
        { GroupName: 'In House' },
        { GroupName: 'Agent Corps' },
        { GroupName: 'Not for Use' }
    ];

    $scope.ChangeGroups = function (name) {
        $scope.selectType = name;
    }
    $scope.GetTitle = function () {
        return ($scope.SelectedTeam ? ($scope.SelectedTeam === "" ? "All Team's " : $scope.SelectedTeam + "s ") : "") + $scope.selectType;
    }
    $scope.ExportExcel = function () {
        JSONToCSVConvertor($scope.filteredCorps, true, $scope.GetTitle());

    }
    $scope.GroupCount = function (g) {
        if (!$scope.CorpEntites) {
            return 0;
        }
        if (g.GroupName == 'All Entities') {
            if ($scope.SelectedTeam) {
                return $scope.CorpEntites.filter(function (o) { return o.Office && o.Office.toLowerCase().trim() == $scope.SelectedTeam.toLowerCase().trim() }).length;
            }
            return $scope.CorpEntites.length;
        }
        var count = 0
        if (g.SubGroups) {
            for (var i = 0; i < g.SubGroups.length; i++) {
                count += $scope.GroupCount(g.SubGroups[i]);
            }
            return count
        }
        var corps = $scope.CorpEntites.filter(function (o) { return (o.Status && o.Status.toLowerCase().trim() == g.GroupName.toLowerCase().trim()) });
        if ($scope.SelectedTeam) {
            corps = corps.filter(function (o) { return o.Office && o.Office.toLowerCase().trim() == $scope.SelectedTeam.toLowerCase().trim() });
        }
        return corps.length;
    }
    $scope.lookupDataSource = new DevExpress.data.ODataStore({
        url: "/odata/LeadsInfoes",
        key: "CategoryID",
        keyType: "Int32"
    });
    $scope.TeamCount = function (teamName) {
        if (!$scope.CorpEntites) {
            return 0;
        }
        var crops = [];
        crops = teamName ? $scope.CorpEntites.filter(function (o) { return o.Office && o.Office.toLowerCase().trim() == teamName.toLowerCase().trim() }) : $scope.CorpEntites;


        if ($scope.selectType && $scope.selectType != $scope.Groups[0].GroupName) {
            crops = crops.filter(function (o) { return o.Status && o.Status.toLowerCase().trim() == $scope.selectType.toLowerCase().trim() })
        }

        return crops.length;
    }
    $scope.EmployeeDataSource = function () {
        var employees = $scope.ptContactServices.getContactsByGroup(4);

        var mSource = new DevExpress.data.CustomStore({
            load: function (loadOptions) {
                if (loadOptions.searchValue) {
                    var q = loadOptions.searchValue;
                    return employees.filter(function (e) { e.Email && (e.Email.toLowerCase() == q.toLowerCase() || e.Name.toLowerCase() == q.toLowerCase()) }).slice(0, 10);
                }
                return employees.slice(0, 10);
            },
            byKey: function (key, extra) {
                // . . .
            },


        });
        return {
            dataSource: mSource,
            searchEnabled: true,
            placeholder: 'Type to Search',
            displayExpr: 'Email',
            valueExpr: 'Email',
            bindingOptions: {
                values: 'EmailTo'
            }
        };
    }
    $scope.EntitiesFilter = function (entity) {
        if ($scope.selectType == 'All Entities' || (entity.Status && $scope.selectType.toLowerCase().trim() == entity.Status.toLowerCase().trim()))
            return true;
        var subs = $scope.Groups.filter(function (o) { return o.GroupName == $scope.selectType })[0];
        if (subs && subs.SubGroups) {
            for (var i = 0; i < subs.SubGroups.length; i++) {
                var sg = subs.SubGroups[i];
                if (entity.Status && sg.GroupName.toLowerCase().trim() == entity.Status.toLowerCase().trim()) {
                    return true;
                }
            }
        }

        return false;
    }
    $scope.selectCurrent = function (contact) {
        $scope.currentContact = contact;
    }
    $scope.SaveCurrent = function () {
        $scope.loadPanelVisible = true;
        $http.post('/Services/ContactService.svc/SaveCorpEntitiy', { c: JSON.stringify($scope.currentContact) }).success(function (data, status, headers, config) {
            $scope.loadPanelVisible = false;
            alert("Save succeed!")
        }).error(function (data, status, headers, config) {
            alert("Get error save corp entitiy : " + JSON.stringify(data))
            $scope.loadPanelVisible = false;
        });
    }
    $scope.AllGroups = function () {
        var HasSub = $scope.Groups.filter(function (o) { return o.SubGroups != null });
        var groups = [];
        for (var i = 0; i < HasSub.length; i++) {
            groups = groups.concat(HasSub[i].SubGroups);
        }
        var HasNotSub = $scope.Groups.filter(function (o) { return o.SubGroups == null && o.GroupName != 'All Entities' });
        groups = groups.concat(HasNotSub);
        return groups;
    }
    $scope.addContactFunc = function () {
        $scope.loadPanelVisible = true;
        $http.post('/Services/ContactService.svc/SaveCorpEntitiy', { c: JSON.stringify($scope.addContact) }).success(function (data, status, headers, config) {
            $scope.loadPanelVisible = false;
            if (!data) {
                alert("Already have a entitity named " + $scope.addContact.CorpName + "! please pick other name");
                return;
            }
            $scope.currentContact = data;
            $scope.CorpEntites.push($scope.addContact);
            alert("Add entity succeed !")
        }).error(function (data, status, headers, config) {
            $scope.loadPanelVisible = false;
            alert('Add buyer Entities error : ' + JSON.stringify(data))
        });
    }
    $scope.AssginEntity = function () {
        $scope.loadPanelVisible = true;
        $http.post('/Services/ContactService.svc/AssginEntity', { c: JSON.stringify($scope.currentContact) }).success(function (data, status, headers, config) {
            $scope.loadPanelVisible = false;
            $scope.currentContact.BBLE = data;
            alert("Assigned succeed !")
        }).error(function (data, status, headers, config) {
            $scope.loadPanelVisible = false;
            alert('Can not find BBLE of address:(' + $scope.currentContact.PropertyAssigned + ") Please make sure this address is available");
        });
    }
    $scope.ChangeTeam = function (team) {
        $scope.SelectedTeam = team;
    }
    $scope.OpenLeadsView = function () {
        var bble = $scope.currentContact.BBLE
        var url = '/ViewLeadsInfo.aspx?id=' + bble;
        OpenLeadsWindow(url, "View Leads Info " + bble);
    }
    $scope.UploadFile = function (fileUploadId, type, field) {
        $scope.loadPanelVisible = true;

        var contact = $scope.currentContact;
        var entityId = contact.EntityId;

        // grab file object from a file input
        var fileData = document.getElementById(fileUploadId).files[0];

        $.ajax({
            url: '/services/ContactService.svc/UploadFile?id=' + entityId + '&type=' + type,
            type: 'POST',
            data: fileData,
            cache: false,
            dataType: 'json',
            processData: false, // Don't process the files
            contentType: "application/octet-stream", // Set content type to false as jQuery will tell the server its a query string request
            success: function (data) {
                alert('successful..');
                $scope.currentContact[field] = data;
                $scope.loadPanelVisible = false;
                $scope.$apply();
            },
            error: function (data) {
                alert('Some error Occurred!');
                $scope.loadPanelVisible = false;
                $scope.$apply();
            }
        });
    }

    //end - view and upload document
}]);