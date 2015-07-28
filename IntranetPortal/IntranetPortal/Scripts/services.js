app = angular.module('PortalApp');

app.factory('ptContactServices', function () {

    var AllContact;
    var PickedContactId = null;
    var cStore = new DevExpress.data.CustomStore({
        load: function (loadOptions) {
            if (AllContact) {
                if (loadOptions.searchValue) {
                    return AllContact.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(loadOptions.searchValue.toLowerCase()) >= 0 } return false });
                }
                return [];
            }
            var d = $.Deferred();
            if (loadOptions.searchValue) {
                $.getJSON('/LegalUI/ContactService.svc/GetContacts?args=' + loadOptions.searchValue).done(function (data) {
                    d.resolve(data);
                });
            } else {
                $.getJSON('/LegalUI/ContactService.svc/LoadContacts').done(function (data) {
                    d.resolve(data);
                    AllContact = data;
                });
            }
            return d.promise();
        },
        byKey: function (key) {
            if (AllContact) {
                return AllContact.filter(function (o) { return o.ContactId == key })[0];
            }
            var d = new $.Deferred();
            $.get('/LegalUI/ContactService.svc/GetAllContacts?id=' + key)
                .done(function (result) {
                    d.resolve(result);
                });
            return d.promise();
        },
        searchExpr: ["Name"]
    });

    function InitContact(id, dataSourceName) {
        return {
            dataSource: dataSourceName ? $scope[dataSourceName] : $scope.ContactDataSource,
            valueExpr: 'ContactId',
            displayExpr: 'Name',
            searchEnabled: true,
            minSearchLength: 2,
            noDataText: "Please input to search",
            bindingOptions: { value: id }
        };
    }

    function GetContactById(id) {
        return AllContact.filter(function (o) { return o.ContactId == id })[0];
    }

    function GetContactByName(teamName) {
        if (AllContact && teamName) {
            var ctax = AllContact.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(teamName.toLowerCase()) >= 0 } return false })[0];
            return AllContact.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(teamName.toLowerCase()) >= 0 } return false })[0];
        }
        return {}
    }

    function GetTeamByName(teamName) {
        if (teamName) {
            return ALLTeam.filter(function (o) { return o.Name == teamName })[0];
        }

    }

    

});