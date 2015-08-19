var app = angular.module('PortalApp');

/* code area steven*/
function NGAddArrayitemScope(scopeId, model) {
    var $scope = angular.element(document.getElementById(scopeId)).scope()
    if (model) {
        var array = $scope.$eval(model);
        if (!array) {
            $scope.$eval(model + '=[{}]');
        } else {

            $scope.$eval(model + '.push({})');

        }
        $scope.$apply();
    }
}
function ScopeCaseDataChanged(getDataFunc) {
    if ($('#CaseData').length == 0) {
        alert("can not find input case data elment");
        $('<input type="hidden" id="CaseData" />').appendTo(document.body);
        return false;
    }
    return $('#CaseData').val() != "" && $('#CaseData').val() != JSON.stringify(getDataFunc());
}
function ScopeResetCaseDataChange(getDataFunc) {
    var caseData = getDataFunc()
    if ($('#CaseData').length == 0) {

        $('<input type="hidden" id="CaseData" />').appendTo(document.body);
    }
    $('#CaseData').val(JSON.stringify(getDataFunc()));
}
function ScopeAutoSave(getDataFunc, SaveFunc) {
    window.setInterval(function () {
        if (ScopeCaseDataChanged(getDataFunc)) {
            var sucessFunc = function () {


            }
            SaveFunc(sucessFunc);
            //ScopeResetCaseDataChange(getDataFunc)
        }
    }, 30000)
}

/* above is global functions */
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
                    result.done(function (dialogResult) {
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

        this.ensureArray = function (scope, modelName) {
            /* caution: due to the ".", don't eval to create an array more than one level*/
            if (!scope.$eval(modelName)) {
                scope.$eval(modelName + '=[]');
            }
        }

        this.ensurePush = function (scope, modelName, data) {
            this.ensureArray(scope, modelName);
            data = data ? data : {}
            var model = scope.$eval(modelName);
            model.push(data);
        }

        this.nullToUndefined = function (obj) {
            for (var property in obj) {
                if (obj.hasOwnProperty(property)) {
                    if (obj[property] === null) {
                        obj[property] = undefined;
                    } else {
                        if (typeof obj[property] == "object") {
                            this.nullToUndefined(obj[property]);
                        }
                    }
                }
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
    this.getContactsByGroup = function (groupId) {
        if (allContact) return allContact.filter(function (x) { return x.GroupId == groupId })

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
                            console.log("Get Short sale Leads failed BBLE =" + res.BBLE + " error : " + JSON.stringify(data1));
                        });

                })
                .error(function (data, status, headers, config) {
                    console.log("Get Short sale failed CaseId= " + caseId + ", error : " + JSON.stringify(data));
                });
        }

        this.getShortSaleCaseByBBLE = function (bble, callback) {
            var url = "/ShortSale/ShortSaleServices.svc/GetCaseByBBLE?bble=" + bble;
            $http.get(url)
                .success(function (data) {
                    var res = data ? data : {};
                    url = "/ShortSale/ShortSaleServices.svc/GetLeadsInfo?bble=" + bble;
                    $http.get(url)
                        .success(function (data1) {
                            res.LeadsInfo = data1;
                            callback(res);
                        }).error(function (data1) {
                            console.log("Get Shor Sale Leads Info fails");
                        });
                }).error(function (data) {
                    console.log("Get Short Sale By BBLE fails.");
                }
            );

        }
    }
]);

app.service('ptFileService', function () {

    this.uploadFile = function (data, bble, callback, cleanup, rename) {
        var fileName = rename == '' ? file.name : rename;
        if (!data || !bble) {
            alert('Upload infomation missing!');
            if (cleanup) cleanup();
        } else {
            bble = bble.trim();
            $.ajax({
                url: '/api/ConstructionCases/UploadFiles?bble=' + bble + '&fileName=' + fileName,
                type: 'POST',
                data: data,
                cache: false,
                processData: false,
                contentType: false,
                success: function (data1) {
                    callback(data1);
                    if (cleanup) cleanup();
                },
                error: function () {
                    if (cleanup) cleanup();
                    alert('upload file fails');
                }
            });
        }
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
                return '/downloadfile.aspx?fileUrl=' + encodeURIComponent(filePath);

        }
    }

    this.resetFileElement = function (ele) {
        ele.val('');
        ele.wrap('<form>').parent('form').trigger('reset');
        ele.unwrap();
        ele.prop('files')[0] = null;
        ele.replaceWith(ele.clone());
    }
}
);

app.service('ptConstructionService', [
    '$http', function ($http) {
        this.getConstructionCases = function (bble, callback) {
            var url = "/api/ConstructionCases/" + bble;
            $http.get(url)
                .success(function (data) {
                    if (callback) callback(data);
                }).error(function (data) {
                    console.log("Get Construction Data fails.");
                });
        }

        this.saveConstructionCases = function (bble, data, callback) {
            if (bble && data) {
                debugger;
                bble = bble.trim();
                var url = "/api/ConstructionCases/" + bble;
                $http.put(url, data)
                    .success(function (res) {
                        if (callback) callback(res);
                        alert("Save successfully!");
                    }).error(function () {
                        console.log('Save CSCase fails.');
                    });
            }
        }
    }
]);