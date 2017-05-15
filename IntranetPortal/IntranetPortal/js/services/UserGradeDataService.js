angular.module('PortalApp').service('UserGradeDataService', function ($http) {
    this.$inject = ['$http'];
    this.localapi = "/api/ExternalData?source=grading&api=";

    this.get = function (id) {
        if (!id) throw "Id cannot be empty";
        var targetapi = "/api/usergradedata/" + id;
        targetapi = this.localapi + targetapi;
        return $http.get(targetapi);
    }

    this.getList = function (refId) {
        if (!refId) throw "BBLE is empty."
        var targetapi = "/api/usergradedata/refid/" + refId;
        targetapi = this.localapi + targetapi;
        return $http.get(targetapi);
    }

    this.create = function (refid, username, gradeData, title, offer, comments) {
        if (!title) return new Promise(function (resolve, reject) { reject("Title cannot be empty.") });
        if (!username) return new Promise(function (resolve, reject) { reject("Username cannot be empty") });
        if (!refid) return new Promise(function (resolve, reject) { reject("Failed to create.") });
        var targetapi = this.localapi + "/api/usergradedata";
        var data = {
            refId: refid,
            username: username,
            data: gradeData,
            title: title,
            offerPrice: offer,
            comments: comments
        }

        return $http.post(targetapi, data);
    }

    this.update = function (id, username, gradeData, offer, comments) {
        if (!id) return new Promise(function (resolve, reject) { reject("Id cannot be empty") });
        if (!username) return new Promise(function (resolve, reject) { reject("Must provide username") });
        comments = comments ? comments : "";
        var targetapi = "/api/usergradedata/" + id;
        targetapi = this.localapi + targetapi;
        var data = {
            username: username,
            data: gradeData,
            offerPrice: offer,
            comments: comments
        }
        return $http.post(targetapi, data);
    }

    this.delete = function (id) {
        if (!id) throw "Id cannot be empty";
        var targetapi = "/api/usergradedata/" + id;
        targetapi = this.localapi + targetapi;
        return $http.delete(targetapi);
    }

    this.getLatest = function (username) {
        if (!username) throw "User cannot be empty";
        var targetapi = "api/usergradedata/user/" + username;
        return $http.get(targetapi);
    }
});

 