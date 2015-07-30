app = angular.module('PortalApp');

app.service('ptContactServices', ['$http', function ($http) {

    var allContact;

    this.getAllContacts = function () {
        if (allContact) return allContact;
        else $http.get('/LegalUI/ContactService.svc/LoadContacts')
          .success(function (data, status) {
              allContact = data;
              return allContact;
          }).error(function (data, status) {
              return {};
          });
    }

    this.getContacts = function (args) {
        if (allContact) return allContact.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(loadOptions.searchValue.toLowerCase()) >= 0 } return false });
        else $http.get('/LegalUI/ContactService.svc/GetContacts?args=' + args)
          .success(function (data, status) {
              return data;
          }).error(function (data, status) {
              return {};
          });
    }

    this.getContactsByID = function (id) {
        if (allContact) return allContact.filter(function (o) { return o.ContactId == key })[0];
        else $http.get('/LegalUI/ContactService.svc/GetAllContacts?id=' + id)
          .success(function (data, status) {
              return data;
          }).error(function (data, status) {
              return {};
          });
    }

    this.GetContactById = function (id) {
        return allContact.filter(function (o) { return o.ContactId == id })[0];
    }

    this.GetContactByName = function (teamName) {
        if (AllContact && teamName) {
            var ctax = allContact.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(teamName.toLowerCase()) >= 0 } return false })[0];
            return allContact.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(teamName.toLowerCase()) >= 0 } return false })[0];
        }
        return {}
    }

    this.GetTeamByName = function (teamName) {
        if (teamName) {
            return ALLTeam.filter(function (o) { return o.Name == teamName })[0];
        }

    }

}]);