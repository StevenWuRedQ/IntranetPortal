var app = angular.module('PortalApp');

app.service('ptCom',  function () {
    this.arrayAdd = function (model) {
        model = model === undefined ? [] : model;
        model.push({});
    }

    this.arrayRemove = function (model, index) {
        if (model && index < model.length) model.splice(index, 1);
    };
})

app.service('ptContactServices', ['$http', 'limitToFilter', function ($http, limitToFilter) {

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
        return $http.get('/Services/ContactService.svc/LoadContacts')
          .then(function (response) {
              return limitToFilter(response.data, 10);
          })
    }

    this.getContacts = function (args, /* optional */ groupId) {
        groupId = groupId === undefined ? null : groupId;
        return $http.get('/Services/ContactService.svc/GetContacts?args=' + args)
          .then(function (response) {
              if (groupId) return limitToFilter(response.data.filter(function (x) { return x.GroupId == groupId }), 10);
              return limitToFilter(response.data, 10);
          })
    }

    this.getContactsByID = function (id) {
        if (allContact) return allContact.filter(function (o) { return o.ContactId == key });
        return $http.get('/Services/ContactService.svc/GetAllContacts?id=' + id)
          .then(function (response) {
              return limitToFilter(response.data, 10);
          })
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

