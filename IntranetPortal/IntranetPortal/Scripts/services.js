var app = angular.module('PortalApp');

app.service('ptCom', [
    function () {

        this.arrayAdd = function (model, data) {
            if (model) {
                data = data === undefined ? {} : data;
                model.push(data);
            }
        }

        this.arrayRemove = function (model, index, confirm, callback) {
            if (model && index < model.length) {
                if (confirm) {
                    var result = DevExpress.ui.dialog.confirm("Delete This?", "Confirm");
                    result.done(function(dialogResult) {
                        if (dialogResult) {
                            var deleteObj = model.splice(index, 1)[0];
                            if (callback) callback(deleteObj);
                        }
                    });
                } else {
                    model.splice(index, 1);
                }
            }
        };

        this.formatAddr = function (strNO, strName, aptNO, city, state, zip) {
            var result = '';
            if (strNO) result += strNO + ' ';
            if (strName) result += strName + ', ';
            if (aptNO) result += 'Apt ' + aptNO + ', ';
            if (city) result += city + ', ';
            if (state) result += state + ', ';
            if (zip) result += zip;
            return result;
        }
        this.capitalizeFirstLetter = function (string) {
            return string.charAt(0).toUpperCase() + string.slice(1);
        };

        this.formatName = function (firstName, middleName, lastName) {
            var result = '';
            if (firstName) result += this.capitalizeFirstLetter(firstName) + ' ';
            if (middleName) result += this.capitalizeFirstLetter(middleName) + ' ';
            if (lastName) result += this.capitalizeFirstLetter(lastName);
            return result;
        }

        this.ensureArray = function (model, scope) {
            if (scope.$eval(model + '==null')) {
                scope.$eval(model + '=[]');
            }
        }
    }]);

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
            });
    }

    this.getContacts = function (args, /* optional */ groupId) {
        groupId = groupId === undefined ? null : groupId;
        return $http.get('/Services/ContactService.svc/GetContacts?args=' + args)
            .then(function (response) {
                if (groupId) return limitToFilter(response.data.filter(function (x) { return x.GroupId == groupId }), 10);
                return limitToFilter(response.data, 10);
            });
    }

    this.getContactsByID = function (id) {
        if (allContact) return allContact.filter(function (o) { return o.ContactId == key });
        return $http.get('/Services/ContactService.svc/GetAllContacts?id=' + id)
            .then(function (response) {
                return limitToFilter(response.data, 10);
            });
    }

    this.getContactById = function (id) {
        if (allContact) return allContact.filter(function (o) { return o.ContactId == id; })[0];
        return null;
    }

    this.getEntities = function (name, status) {

        status = status === undefined ? 'Available' : status;
        name = name ? '' : name;
        return $http.get('/Services/ContactService.svc/GetCorpEntityByStatus?n=' + name + '&s=' + status)
            .then(function (res) {
                return limitToFilter(res.data, 10);
            });


    }

    this.getContactByName = function (name) {
        if (allContact) return allContact.filter(function (o) { if (o.Name && name) return o.Name.trim().toLowerCase() === name.trim().toLowerCase() })[0];
        return {};
    }

    this.getContact = function (id, name) {
        if (allContact) return allContact.filter(function (o) { if (o.Name && name) return o.ContactId == id && o.Name.trim().toLowerCase() === name.trim().toLowerCase() })[0];
        return {};
    }

    this.getTeamByName = function (teamName) {
        if (allTeam) {
            return allTeam.filter(function (o) { if (o.Name && teamName) return o.Name.trim() == teamName.trim() })[0];
        }
        return {};

    }

}]);

app.service('ptShortsSaleService', [
    '$http', function ($http) {
        this.getShortSaleCase = function (caseId, callback) {
            var url = "/ShortSale/ShortSaleServices.svc/GetCase?caseId=" + caseId;
            var res;
            $http.get(url)
                .success(function (data) {
                    res = data;
                    var leadsInfoUrl = "/ShortSale/ShortSaleServices.svc/GetLeadsInfo?bble=" + res.BBLE;
                    $http.get(leadsInfoUrl)
                        .success(function (data1) {
                            res.LeadsInfo = data1;
                            callback(res);
                        }).error(function (data1) {
                            alert("Get Short sale Leads failed BBLE =" + res.BBLE + " error : " + JSON.stringify(data1));
                        });

                })
                .error(function (data, status, headers, config) {
                    alert("Get Short sale failed CaseId= " + caseId + ", error : " + JSON.stringify(data));
                });
        }
    }
]);

app.service('ptFileService', function () {
    this.uploadFile = function (file, rename, callback) {
        $.ajax({
            url: 'xxx?fileName=' + rename,
            type: 'POST',
            data: file,
            cache: false,
            processData: false,
            contentType: "application/octet-stream",
            success: function (data) {
                debugger;
                callback(data);
            },
            error: function (data) {
                debugger;
                alert('upload file fails');
            }
        });
    }

    this.getFileName = function (fullPath) {
        if (fullPath) {
            var paths = fullPath.split('/');
            return paths[paths.length - 1];
        }
        return '';
    }

    this.getFileExt = function (fullPath) {
        if (fullPath) {
            var exts = fullPath.split('.');
            return exts[exts.length - 1].toLowerCase();
        }
        return '';
    }

    this.makePreviewUrl = function (filePath) {
        var ext = this.getFileExt(filePath);
        switch (ext) {
            case 'pdf':
                return '/pdfViewer/web/viewer.html?file=' + encodeURIComponent('/downloadfile.aspx?pdfUrl=') + encodeURIComponent(filePath);
                /*
                case 'jpg':
                    return '';
                case 'jpeg':
                    return '';
                case 'bmp':
                    return '';
                case 'gif':
                    return '';
                case 'png':
                    return '';
                    */
            default:
                return '/downloadfile.aspx?pdfUrl=' + encodeURIComponent(filePath);

        }
    }
}
);