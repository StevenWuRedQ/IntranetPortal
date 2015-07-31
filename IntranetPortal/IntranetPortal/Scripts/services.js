app = angular.module('PortalApp');

app.service('ptContactServices', ['$http', function ($http) {

    var allContact;
    var allTeam;

    (function () {
        if (!allContact) {
            $http.get('/Services/ContactService.svc/LoadContacts')
           .success(function (data, status) {
               allContact = data;
           }).error(function (data, status) {
               allContact = [];
           });
        }

        if (!allTeam) {
            $http.get('/Services/TeamService.svc/GetAllTeam')
            .success(function (data, status) {
                allTeam = data;
            })
            .error(function (data, status) {
                allTeam = [];
            });
        }

    }());

    this.getAllContacts = function () {
        if (allContact) return allContact;
        else $http.get('/Services/ContactService.svc/LoadContacts')
          .success(function (data, status) {
              allContact = data;
              return allContact;
          }).error(function (data, status) {
              return [];
          });
    }

    this.getContacts = function (args) {
        if (allContact) return allContact.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(loadOptions.searchValue.toLowerCase()) >= 0 } return false });
        else $http.get('/Services/ContactService.svc/GetContacts?args=' + args)
          .success(function (data, status) {
              return data;
          }).error(function (data, status) {
              return [];
          });
    }

    this.getContactsByID = function (id) {
        if (allContact) return allContact.filter(function (o) { return o.ContactId == key })[0];
        else $http.get('/Services/ContactService.svc/GetAllContacts?id=' + id)
          .success(function (data, status) {
              return data;
          }).error(function (data, status) {
              return [];
          });
    }

    this.getContactById = function (id) {
        if (allContact) return allContact.filter(function (o) { return o.ContactId == id })[0];
    }

    this.getContactByName = function (name) {
        if (allContact) return allContact.filter(function (o) { if (o.Name && name) return o.Name.trim().toLowerCase() === name.trim().toLowerCase() })[0];
    }

    this.getContact = function (id, name) {
        if (allContact) return allContact.filter(function (o) { if (o.Name && name) return o.ContactId == id && o.Name.trim().toLowerCase() === name.trim().toLowerCase() })[0];
    }

    this.getTeamByName = function (teamName) {
        if (allTeam) {
            return allTeam.filter(function (o) { if (o.Name && teamName) return o.Name.trim() == teamName.trim() })[0];
        }

    }

}]);