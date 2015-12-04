var portalApp = angular.module('PortalApp', ['ngSanitize', 'ngAnimate', 'dx', 'ngMask', 'ui.bootstrap', 'ui.select', 'ui.layout']);
angular.module('PortalApp').
controller('MainCtrl', ['$rootScope', '$uibModal', '$timeout', function ($rootScope, $uibModal, $timeout) {
    $rootScope.AlertModal = null;
    $rootScope.ConfirmModal = null;
    $rootScope.loadingCover = document.getElementById('LodingCover');
    $rootScope.panelLoading = false;

    $rootScope.alert = function (message) {
        $rootScope.alertMessage = message ? message : '';
        $rootScope.AlertModal = $uibModal.open({
            templateUrl: 'AlertModal',
        });
    }

    $rootScope.alertOK = function () {
        $rootScope.AlertModal.close();
    }

    $rootScope.confirm = function (message) {
        $rootScope.confirmMessage = message ? message : '';
        $rootScope.ConfirmModal = $uibModal.open({
            templateUrl: 'ConfirmModal'
        });
        return $rootScope.ConfirmModal.result;
    }

    $rootScope.confirmYes = function () {
        $rootScope.ConfirmModal.close(true);
    }

    $rootScope.confirmNo = function () {
        $rootScope.ConfirmModal.close(false);
    }


    $rootScope.showLoading = function (divId) {
        $($rootScope.loadingCover).show();
    }

    $rootScope.hideLoading = function (divId) {
        $($rootScope.loadingCover).hide();
    }

    $rootScope.toggleLoading = function () {
        $rootScope.panelLoading = !$scope.panelLoading;
    }
    $rootScope.startLoading = function () {
        $rootScope.panelLoading = true;
    }
    $rootScope.stopLoading = function () {
        $timeout(function () {
            $rootScope.panelLoading = false;
        });
    }
}]);
angular.module("PortalApp").
service("ptCom", ["$http", "$rootScope", function ($http, $rootScope) {

    var that = this;

    /******************Stven code area*********************/
    this.DocGenerator = function (tplName, data, successFunc) {
        $http.post("/Services/Documents.svc/DocGenrate", { "tplName": tplName, "data": JSON.stringify(data) }).success(function (data) {
            successFunc(data);
        }).error(function (data, status) {
            alert("Fail to save data. status: " + status + " Error : " + JSON.stringify(data));
        });
    }; /******************End Stven code area*********************/

    this.arrayAdd = function (model, data) {
        if (model) {
            data = data === undefined ? {} : data;
            model.push(data);
        }
    };
    this.arrayRemove = function (model, index, confirm, callback) {
        if (model && index < model.length) {
            if (confirm) {
                var x = that.confirm("Delete This?", "").then(function (r) {
                    if (r) {
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
    };
    this.capitalizeFirstLetter = function (string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    };

    this.formatName = function (firstName, middleName, lastName) {
        var result = '';
        if (firstName) result += that.capitalizeFirstLetter(firstName) + ' ';
        if (middleName) result += that.capitalizeFirstLetter(middleName) + ' ';
        if (lastName) result += that.capitalizeFirstLetter(lastName);
        return result;
    };
    this.ensureArray = function (scope, modelName) {
        /* caution: due to the ".", don't eval to create an array more than one level*/
        if (!scope.$eval(modelName)) {
            scope.$eval(modelName + '=[]');
        }
    };
    this.ensurePush = function (scope, modelName, data) {
        that.ensureArray(scope, modelName);
        data = data ? data : {};
        var model = scope.$eval(modelName);
        model.push(data);
    };
    // when use jquery.extend, jquery will override the dst even src is null,
    // this function convert null recursively to make the extend works as expected 
    this.nullToUndefined = function (obj) {
        for (var property in obj) {
            if (obj.hasOwnProperty(property)) {
                if (obj[property] === null) {
                    obj[property] = undefined;
                } else {
                    if (typeof obj[property] === "object") {
                        that.nullToUndefined(obj[property]);
                    }
                }
            }
        }
    };
    this.printDiv = function (divID) {
        var divToPrint = document.getElementById(divID);
        var popupWin = window.open('', '_blank', 'width=300,height=300');
        popupWin.document.open();
        popupWin.document.write('<html <head><link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet" type="text/css" /><link href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" /><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/3.0.3/normalize.min.css" /><link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" /><link rel="stylesheet" href="/Content/bootstrap-datepicker3.css" /><link rel="stylesheet" href="http://cdn3.devexpress.com/jslib/15.1.6/css/dx.common.css" type="text/css" /><link rel="stylesheet" href="http://cdn3.devexpress.com/jslib/15.1.6/css/dx.light.css" /><link href="/css/stevencss.css" rel="stylesheet" type="text/css" /></head><body onload="window.print()">' + divToPrint.innerHTML + '</html>');
        popupWin.document.close();


    };
    this.postRequest = function (url, data) {
        $.post(url, data, function (retData) {
            $("body").append("<iframe src='" + retData.url + "' style='display: none;' ></iframe>");
        });
    };
    this.alert = function (message) {
        $rootScope.alert(message);
    };
    this.confirm = function (message) {
        return $rootScope.confirm(message);
    };
    this.addOverlay = function () {
        $rootScope.addOverlay();
    };
    this.stopLoading = function () {
        $rootScope.stopLoading();
    }
    this.startLoading = function () {
        $rootScope.startLoading();
    }

    this.removeOverlay = function () {
        $rootScope.removeOverlay();
    }; // get next index of value in the array, 
    this.next = function (array, value, from) {
        return array.indexOf(value, from);
    };
    this.previous = function (array, value, from) {
        var index = -1;
        for (var i = 0 ; i < from ; i++) {
            if (array[i] === value)
                index = i;
        }
        return index;
    };
    this.saveBlob = function (blob, fileName) {
        var a = document.createElement("a");
        a.style = "display: none";
        var xurl = window.URL.createObjectURL(blob);
        a.href = xurl;
        a.download = fileName;

        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(xurl);
        document.body.removeChild(a);

    };
    this.toUTCLocaleDateString = function (d) {
        var tempDate = new Date(d);
        return (tempDate.getUTCMonth() + 1) + "/" + tempDate.getUTCDate() + "/" + tempDate.getUTCFullYear();
    };
}]).
service('ptContactServices', ['$http', 'limitToFilter', function ($http, limitToFilter) {

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
    };
    this.getContactsByGroup = function (groupId) {
        if (allContact) return allContact.filter(function (x) { return x.GroupId == groupId });
    };
    this.getContacts = function (args, /* optional */ groupId) {
        groupId = groupId === undefined ? null : groupId;
        return $http.get('/Services/ContactService.svc/GetContacts?args=' + args)
            .then(function (response) {
                if (groupId) return limitToFilter(response.data.filter(function (x) { return x.GroupId == groupId }), 10);
                return limitToFilter(response.data, 10);
            });
    };
    this.getContactsByID = function (id) {
        if (allContact) return allContact.filter(function (o) { return o.ContactId == key });
        return $http.get('/Services/ContactService.svc/GetAllContacts?id=' + id)
            .then(function (response) {
                return limitToFilter(response.data, 10);
            });
    };
    this.getContactById = function (id) {
        if (allContact) return allContact.filter(function (o) { return o.ContactId == id; })[0];
        return null;
    };
    this.getEntities = function (name, status) {

        status = status === undefined ? 'Available' : status;
        name = name ? '' : name;
        return $http.get('/Services/ContactService.svc/GetCorpEntityByStatus?n=' + name + '&s=' + status)
            .then(function (res) {
                return limitToFilter(res.data, 10);
            });


    };
    this.getContactByName = function (name) {
        if (allContact) return allContact.filter(function (o) { if (o.Name && name) return o.Name.trim().toLowerCase() === name.trim().toLowerCase() })[0];
        return {};
    };
    this.getContact = function (id, name) {
        if (allContact) return allContact.filter(function (o) { if (o.Name && name) return o.ContactId == id && o.Name.trim().toLowerCase() === name.trim().toLowerCase() })[0] || {};
        return {};
    };
    this.getTeamByName = function (teamName) {
        if (allTeam) {
            return allTeam.filter(function (o) { if (o.Name && teamName) return o.Name.trim() == teamName.trim() })[0];
        }
        return {};

    };


}]).
service('ptShortsSaleService', ['$http', function ($http) {
    this.getShortSaleCase = function (caseId, callback) {
        var url = "/ShortSale/ShortSaleServices.svc/GetCase?caseId=" + caseId;
        $http.get(url)
            .success(function (data) {
                callback(data);
            })
            .error(function (data) {
                console.log("Get Short sale failed CaseId= " + caseId + ", error : " + JSON.stringify(data));
            });
    };
    this.getShortSaleCaseByBBLE = function (bble, callback) {
        var url = "/ShortSale/ShortSaleServices.svc/GetCaseByBBLE?bble=" + bble;
        $http.get(url)
            .success(function (data) {
                callback(data);
            }).error(function () {
                console.log("Get Short Sale By BBLE fails.");
            }
        );

    };
    this.getBuyerTitle = function (bble, callback) {
        var url = "/api/ShortSale/GetBuyerTitle?bble=";
        $http.get(url + bble)
        .then(function succ(res) {
            if (callback) callback(null, res);
        }, function error() {
            if (callback) callback("Fail to get buyer title for bble: " + bble, null);
        });
    };
}]).
service('ptLeadsService', ["$http", function ($http) {
    this.getLeadsByBBLE = function (bble, callback) {
        var leadsInfoUrl = "/ShortSale/ShortSaleServices.svc/GetLeadsInfo?bble=" + bble;
        $http.get(leadsInfoUrl)
        .success(function (data) {
            callback(data);
        }).error(function (data) {
            console.log("Get Short sale Leads failed BBLE =" + bble + " error : " + JSON.stringify(data));
        });
    };
}
]).
factory('ptHomeBreakDownService', ["$http", function ($http) {
    return {
        loadByBBLE: function (bble, callback) {
            var url = '/ShortSale/ShortSaleServices.svc/LoadHomeBreakData?bble=' + bble;
            $http.get(url)
                .success(function (data) {
                    callback(data);
                }).error(function () {
                    console.log('load home breakdown fail. BBLE: ' + bble);
                });
        },
        save: function (bble, data, callback) {
            var url = '/ShortSale/ShortSaleServices.svc/SaveBreakData';
            var postData = {
                "bble": bble,
                "jsonData": JSON.stringify(data)
            };
            $http.post(url, postData)
                .success(function (res) {
                    callback(res);
                }).error(function () {
                    console.log('save home breakdone fail. BBLE: ' + bble);
                });

        }
    };
}
]).
service('ptFileService', function () {
    this.uploadFile = function (data, bble, rename, folder, type, callback) {
        switch (type) {
            case 'construction':
                this.uploadConstructionFile(data, bble, rename, folder, callback);
                break;
            case 'title':
                this.uploadTitleFile(data, bble, rename, folder, callback);
                break;
            default:
                this.uploadConstructionFile(data, bble, rename, folder, callback);
                break;

        }
    };
    this.uploadTitleFile = function (data, bble, rename, folder, callback) {
        var fileName = rename ? rename : '';
        var folder = folder ? folder : '';
        if (!data || !bble) {
            callback('Upload infomation missing!');
        } else {
            bble = bble.trim();
            $.ajax({
                url: '/api/Title/UploadFiles?bble=' + bble + '&fileName=' + fileName + '&folder=' + folder,
                type: 'POST',
                data: data,
                cache: false,
                processData: false,
                contentType: false,
                success: function (data1) {
                    callback(null, data1, rename);
                },
                error: function () {
                    callback('Upload fails!', null, rename);
                }
            });
        }
    };
    this.uploadConstructionFile = function (data, bble, rename, folder, callback) {
        var fileName = rename ? rename : '';
        var tofolder = folder ? folder : '';
        if (!data || !bble) {
            callback('Upload infomation missing!');
        } else {
            bble = bble.trim();
            $.ajax({
                url: '/api/ConstructionCases/UploadFiles?bble=' + bble + '&fileName=' + fileName + '&folder=' + tofolder,
                type: 'POST',
                data: data,
                cache: false,
                processData: false,
                contentType: false,
                success: function (data1) {
                    callback(null, data1, rename);
                },
                error: function () {
                    callback('Upload fails!', null, rename);
                }
            });
        }
    };
    this.getFileName = function (fullPath) {
        var paths;
        if (fullPath) {
            if (this.isIE(fullPath)) {
                paths = fullPath.split('\\');
                return this.cleanName(paths[paths.length - 1]);
            } else {
                paths = fullPath.split('/');
                return this.cleanName(paths[paths.length - 1]);
            }
        }
        return '';
    };
    this.getFileExt = function (fullPath) {
        if (fullPath && fullPath.indexOf('.') > -1) {
            var exts = fullPath.split('.');
            return exts[exts.length - 1].toLowerCase();
        }
        return '';
    };
    this.isPicture = function (fullPath) {
        var ext = this.getFileExt(fullPath);
        var pictureExts = ['jpg', 'jpeg', 'gif', 'bmp', 'png'];
        return pictureExts.indexOf(ext) > -1;
    };
    this.getFileFolder = function (fullPath) {
        if (fullPath) {
            var paths = fullPath.split('/');
            var folderName = paths[paths.length - 2];
            var topFolders = ['Construction', 'Title'];
            if (topFolders.indexOf(folderName) < 0) {
                return folderName;
            } else {
                return '';
            }
        }
        return '';
    };
    this.makePreviewUrl = function (filePath) {
        var ext = this.getFileExt(filePath);
        switch (ext) {
            case 'pdf':
                return '/pdfViewer/web/viewer.html?file=' + encodeURIComponent('/downloadfile.aspx?pdfUrl=') + encodeURIComponent(filePath);
                break;
            case 'xls':
            case 'xlsx':
            case 'doc':
            case 'docx':
                return '/downloadfile.aspx?fileUrl=' + encodeURIComponent(filePath) + '&edit=true';
                break;
            case 'jpg':
            case 'jpeg':
            case 'bmp':
            case 'gif':
            case 'png':
                return '/downloadfile.aspx?fileUrl=' + encodeURIComponent(filePath);
                break;
            default:
                return '/downloadfile.aspx?fileUrl=' + encodeURIComponent(filePath);

        }
    };
    this.onFilePreview = function (filePath) {

        var ext = this.getFileExt(filePath);
        switch (ext) {
            case 'pdf':
                window.open('/pdfViewer/web/viewer.html?file=' + encodeURIComponent('/downloadfile.aspx?pdfUrl=') + encodeURIComponent(filePath));
                break;
            case 'xls':
            case 'xlsx':
            case 'doc':
            case 'docx':
                window.open('/downloadfile.aspx?fileUrl=' + encodeURIComponent(filePath) + '&edit=true');
                break;
            case 'jpg':
            case 'jpeg':
            case 'bmp':
            case 'gif':
            case 'png':
                $.fancybox.open('/downloadfile.aspx?fileUrl=' + encodeURIComponent(filePath));
                break;
            case 'txt':
                $.fancybox.open([
                    {
                        type: 'ajax',
                        href: '/downloadfile.aspx?fileUrl=' + encodeURIComponent(filePath),
                    }
                ]);
                break;
            default:
                window.open('/downloadfile.aspx?fileUrl=' + encodeURIComponent(filePath));

        }
    };
    this.resetFileElement = function (el) {
        el.val('');
        el.wrap('<form>').parent('form').trigger('reset');
        el.unwrap();
        el.prop('files')[0] = null;
        el.replaceWith(el.clone());
    };
    this.cleanName = function (filename) {
        return filename.replace(/[^a-z0-9_\-\.()]/gi, '_');
    };
    this.isIE = function (fileName) {
        return fileName.indexOf(':\\') > -1;
    };
    this.getThumb = function (thumbId) {
        return '/downloadfile.aspx?thumb=' + thumbId;

    };
    this.trunc = function (fileName, length) {
        return _.trunc(fileName, length);

    };
}).
service('ptConstructionService', ['$http', function ($http) {
    this.getConstructionCases = function (bble, callback) {
        var url = "/api/ConstructionCases/" + bble;
        $http.get(url)
            .success(function (data) {
                if (callback) callback(data);
            }).error(function (data) {
                console.log("Get Construction Data fails.");
            });
    };
    this.saveConstructionCases = function (bble, data, callback) {
        if (bble && data) {
            bble = bble.trim();
            var url = "/api/ConstructionCases/" + bble;
            $http.put(url, data)
                .success(function (res) {
                    if (callback) callback(res);
                }).error(function () {
                    alert('Save CSCase fails.');
                });
        }
    };
    this.getDOBViolations = function (bble, callback) {
        if (bble) {
            var url = "/api/ConstructionCases/GetDOBViolations?bble=" + bble;
            $http.get(url)
            .success(function (res) {
                if (callback) callback(null, res);
            }).error(function () {
                if (callback) callback("load dob violations fails");
            });
        } else {
            if (callback) callback("bble is missing");
        }
    };
    this.getECBViolations = function (bble, callback) {
        if (bble) {
            var url = "/api/ConstructionCases/GetECBViolations?bble=" + bble;
            $http.get(url)
            .success(function (res) {
                if (callback) callback(null, res);
            }).error(function () {
                if (callback) callback("load ecb violations fails");
            });
        }
    };
}
]).
factory('ptLegalService', function () {
    return {
        load: function (bble, callback) {
            var url = '/LegalUI/LegalUI.aspx/GetCaseData';
            var d = { bble: bble };
            $.ajax({
                type: "POST",
                url: url,
                data: JSON.stringify(d),
                dataType: 'json',
                contentType: "application/json",
                success: function (res) {
                    callback(null, res);
                },
                error: function () {
                    callback('load data fails');
                }
            });
        },
        savePreQuestions: function (bble, createBy, data, callback) {
            var url = '/LegalUI/LegalServices.svc/StartNewLegalCase';
            var d = {
                bble: bble,
                casedata: JSON.stringify({ PreQuestions: data }),
                createBy: createBy,
            };
            $.ajax({
                type: "POST",
                url: url,
                data: JSON.stringify(d),
                dataType: "json",
                contentType: "application/json",
                success: function (res) {
                    callback(null, res);
                },
                error: function () {
                    callback('load data fails');
                }
            });
        }
    };
}).
factory('ptEntityService', ['$http', function ($http) {
    return {
        getEntityByBBLE: function (bble, callback) {
            var url = '/api/CorporationEntities/ByBBLE?BBLE=' + bble;
            $http.get(url).then(function success(res) {
                if (callback) callback(null, res.data);
            }, function error(res) {
                if (callback) callback("load fail", res.data);
            });
        }
    };
}]);
angular.module("PortalApp").
filter("ByContact", function () {
    return function (movies, contact) {
        var items = {

            out: []
        };
        if ($.isEmptyObject(contact) || contact.Type === null) {
            return movies;
        }
        angular.forEach(movies, function (value, key) {
            if (value.Type === contact.Type) {
                if (contact.CorpName === '' || contact.CorpName === value.CorpName) {
                    items.out.push(value);
                }
            }
        });
        return items.out;
    };
}).
filter('unsafe', ['$sce', function ($sce) { return $sce.trustAsHtml; }]);

angular.module("PortalApp").
directive('ssDate', function () {
    return {
        restrict: 'A',
        scope: true,
        compile: function (tel, tAttrs) {
            return {
                post: function (scope, el, attrs) {
                    $(el).datepicker({
                        forceParse: false
                    });
                    scope.$watch(attrs.ngModel, function (newValue, oldValue) {
                        var dateStr = newValue;
                        if (dateStr && typeof dateStr === 'string' && dateStr.indexOf('T') > -1) {

                            var dd = new Date(dateStr);
                            dd = (dd.getUTCMonth() + 1) + '/' + (dd.getUTCDate()) + '/' + dd.getUTCFullYear();
                            $(el).datepicker('update', new Date(dd))
                        }
                    });
                }
            }



        }
    };
}).
directive('ptRightClick', ['$parse', function ($parse) {
    return function (scope, element, attrs) {
        var fn = $parse(attrs.ngRightClick);
        element.bind('contextmenu', function (event) {
            scope.$apply(function () {
                event.preventDefault();
                fn(scope, { $event: event });
            });
        });
    };
}]).
directive('inputMask', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {
            $(el).mask(attrs.inputMask);
            $(el).on('change', function () {
                scope.$eval(attrs.ngModel + "='" + el.val() + "'");
            });
        }
    };
}).
directive('bindId', ['ptContactServices', function (ptContactServices) {
    return {
        restrict: 'A',
        link: function postLink(scope, el, attrs) {
            scope.$watch(attrs.bindId, function (newValue, oldValue) {
                if (newValue != oldValue) {
                    var contact = ptContactServices.getContactById(newValue);
                    if (contact) scope.$eval(attrs.ngModel + "='" + contact.Name + "'");
                }
            });
        }

    }
}]).
directive('ptInitModel', function () {
    return {
        restrict: 'A',
        require: '?ngModel',
        priority: 99,
        link: function (scope, el, attrs) {
            scope.$watch(attrs.ptInitModel, function (newVal) {
                if (!scope.$eval(attrs.ngModel) && newVal) {
                    if (typeof newVal == 'string') newVal = newVal.replace(/'/g, "\\'");
                    scope.$eval(attrs.ngModel + "='" + newVal + "'");
                }
            });
        }
    }
}).
directive('ptInitBind', function () { //one way bind of ptInitModel
    return {
        restrict: 'A',
        require: '?ngBind',
        link: function (scope, el, attrs) {
            scope.$watch(attrs.ptInitBind, function (newVal) {
                if (!scope.$eval(attrs.ngBind) && newVal) {
                    if (typeof newVal == 'string') newVal = newVal.replace(/'/g, "\\'");
                    scope.$eval(attrs.ngBind + "='" + newVal + "'");
                }
            });
        }
    }
}).
directive('radioInit', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {
            scope.$eval(attrs.ngModel + "=" + attrs.ngModel + "==null?" + attrs.radioInit + ":" + attrs.ngModel);
            scope.$watch(attrs.ngModel, function () {
                var bVal = scope.$eval(attrs.ngModel);
                bVal = bVal != null && (bVal == 'true' || bVal == true);
                scope.$eval(attrs.ngModel + "=" + bVal.toString());
            });
        }
    }
}).
directive('moneyMask', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {

            scope.$watch(attrs.ngModel, function () {
                if ($(el).is(":focus")) return;
                $(el).formatCurrency();
            });
            $(el).on('blur', function () { $(this).formatCurrency(); });
            $(el).on('focus', function () { $(this).toNumber() });

        },
    };
}).
directive('numberMask', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {

            scope.$watch(attrs.ngModel, function () {
                if ($(el).is(":focus")) return;
                $(el).formatCurrency({ symbol: "" });
            });
            $(el).on('blur', function () { $(this).formatCurrency({ symbol: "" }); });
            $(el).on('focus', function () { $(this).toNumber() });

        },
    };
}).
directive('integerMask', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {

            scope.$watch(attrs.ngModel, function () {
                if ($(el).is(":focus")) return;
                $(el).formatCurrency({ symbol: "", roundToDecimalPlace: 0 });
            });
            $(el).on('blur', function () { $(this).formatCurrency({ symbol: "", roundToDecimalPlace: 0 }); });
            $(el).on('focus', function () { $(this).toNumber() });

        },
    };
}).
directive('percentMask', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {

            scope.$watch(attrs.ngModel, function () {
                if ($(el).is(":focus")) return;
                $(el).formatCurrency({ symbol: "%", positiveFormat: '%n%s' });
            });
            $(el).on('blur', function () { $(this).formatCurrency({ symbol: "%", positiveFormat: '%n%s' }); });
            $(el).on('focus', function () { $(this).toNumber() });

        },
    };
}).
directive('ptRadio', function () {
    return {
        restrict: 'E',
        template:
            '<input type="checkbox" id="{{name}}Y" ng-model="model" class="ss_form_input">' +
            '<label for="{{name}}Y" class="input_with_check"><span class="box_text">{{trueValue}}&nbsp</span></label>' +
            '<input type="checkbox" id="{{name}}N" ng-model="model" ng-true-value="false" ng-false-value="true" class="ss_form_input">' +
            '<label for="{{name}}N" class="input_with_check"><span class="box_text">{{falseValue}}&nbsp</span></label>',
        scope: {
            model: '=',
            name: '@',
            defaultValue: '@',
            trueValue: '@',
            falseValue: '@'
        },
        link: function (scope, el, attrs) {
            scope.trueValue = scope.trueValue ? scope.trueValue : 'yes';
            scope.falseValue = scope.falseValue ? scope.falseValue : 'no';
            scope.defaultValue = scope.defaultValue === 'true' ? true : false;
            scope.model = scope.model == null ? scope.defaultValue : scope.model;
        }

    }
}).
directive('ptCollapse', function () {
    return {
        restrict: 'E',
        template:
            '<i class="fa fa-compress icon_btn text-primary" ng-show="!model" ng-click="model=!model"></i>' +
            '<i class="fa fa-expand icon_btn text-primary" ng-show="model" ng-click="model=!model"></i>',
        scope: {
            model: '=',
        },
        link: function postLink(scope, el, attrs) {
            var bVal = scope.model;
            scope.model = bVal === undefined ? false : bVal;
        }

    }
}).
directive('ckEditor', [function () {
    return {
        require: '?ngModel',
        link: function (scope, elm, attr, ngModel) {

            var ck = CKEDITOR.replace(elm[0], {
                allowedContent: true,
                height: 450,
            });

            ck.on('pasteState', function () {
                scope.$apply(function () {
                    ngModel.$setViewValue(ck.getData());
                });
            });

            ngModel.$render = function (value) {
                ck.setData(ngModel.$modelValue);
            };
        }
    };
}]).
directive('ptAdd', function () {
    return {
        restrict: 'E',
        template: '<i class="fa fa-plus-circle icon_btn text-primary tooltip-examples" title="Add"></i>',
    }
}).
directive('ptDel', function () {
    return {
        restrict: 'E',
        template: '<i class="fa fa-times icon_btn text-danger tooltip-examples" title="Delete"></i>',
    }
}).
directive('ptFile', ['ptFileService', '$timeout', function (ptFileService, $timeout) {
    return {
        restrict: 'E',
        templateUrl: '/js/templates/ptfile.html',
        scope: {
            fileModel: '=',
            fileBble: '=',
            fileName: '@',
            fileId: '@',
            uploadType: '@'
        },
        link: function (scope, el, attrs) {
            scope.uploadType = scope.uploadType || 'construction';
            scope.ptFileService = ptFileService;
            scope.fileChoosed = false;
            scope.loading = false;
            scope.delFile = function () {
                scope.fileModel = null;
            }
            scope.delChoosed = function () {
                scope.File = null;
                scope.fileChoosed = false;
                var fileEl = el.find('input:file')[0]
                fileEl.value = ''
            }
            scope.toggleLoading = function () {
                scope.loading = !scope.loading;
            }
            scope.startLoading = function () {
                scope.loading = true;
            }
            scope.stopLoading = function () {
                $timeout(function () {
                    scope.loading = false;
                });
            }
            scope.uploadFile = function () {
                scope.startLoading();
                var data = new FormData();
                data.append("file", scope.File);
                var targetName = ptFileService.getFileName(scope.File.name);
                ptFileService.uploadFile(data, scope.fileBble, targetName, '', scope.uploadType, function (error, data) {
                    scope.stopLoading();
                    if (error) {
                        alert(error);
                    } else {
                        scope.$apply(function () {
                            scope.fileModel = {}
                            scope.fileModel.path = data[0];
                            if (data[1]) scope.fileModel.thumb = data[1];
                            scope.fileModel.name = ptFileService.getFileName(scope.fileModel.path);
                            scope.fileModel.uploadTime = new Date();
                            scope.delChoosed();
                        });
                    }

                });
            }
            el.find('input:file').bind('change', function () {
                var file = this.files[0];
                if (file) {
                    scope.$apply(function () {
                        scope.File = file;
                        scope.fileChoosed = true;
                    });
                }
            });

            scope.modifyName = function (mdl) {
                if (mdl) {
                    scope.ModifyNamePop = true;
                    scope.NewFileName = mdl.name ? mdl.name : '';
                    scope.editingFileModel = mdl;
                    scope.editingFileExt = ptFileService.getFileExt(scope.NewFileName);
                }

            }
            scope.onModifyNamePopClose = function () {
                scope.NewFileName = '';
                scope.editingFileModel = null;
                scope.editingFileExt = '';
                scope.ModifyNamePop = false;

            }
            scope.onModifyNamePopSave = function () {
                if (scope.NewFileName) {
                    if (scope.NewFileName.indexOf('.') > -1) {
                        scope.editingFileModel.name = scope.NewFileName;
                    } else {
                        scope.editingFileModel.name = scope.NewFileName + '.' + scope.editingFileExt;
                    }
                }
                scope.editingFileModel = null;
                scope.editingFileExt = '';
                scope.ModifyNamePop = false;

            }


        }
    }
}]).
directive('ptFiles', ['$timeout', 'ptFileService', 'ptCom', function ($timeout, ptFileService, ptCom) {
    return {
        restrict: 'E',
        templateUrl: '/js/templates/ptfiles.html',
        scope: {
            fileModel: '=',
            fileBble: '=',
            fileId: '@',
            fileColumns: '@',       // addtion information
            folderEnable: '@',
            baseFolder: '@',
            uploadType: '@'         // control server folder, implete specific method in the service

        },
        link: function (scope, el, attrs) {
            scope.uploadType = scope.uploadType || 'construction';
            scope.ptFileService = ptFileService;
            scope.ptCom = ptCom;

            // init scope variale
            scope.files = [];
            scope.columns = [];
            scope.nameTable = [];   // record choosen files
            scope.currentFolder = '';
            scope.showFolder = false;

            scope.loading = false;
            scope.folderEnable = scope.folderEnable === 'true' ? true : false;
            scope.baseFolder = scope.baseFolder ? scope.baseFolder : '';


            if (scope.fileColumns) {
                scope.columns = scope.fileColumns.split('|');
                _.each(scope.columns, function (elm) {
                    elm.trim();
                });
            }
            scope.folders = _.without(_.uniq(_.pluck(scope.fileModel, 'folder')), undefined, '')

            scope.$watch('fileBble', function (newV, oldV) {
                scope.currentFolder = '';
                scope.baseFolder = scope.baseFolder ? scope.baseFolder : '';
                scope.folders = _.without(_.uniq(_.pluck(scope.fileModel, 'folder')), undefined, '')
            })

            $(el).find('input:file').change(function () {
                var files = this.files;
                scope.addFiles(files);
                this.value = '';
            });
            $(el).find('.drop-area')
                .on('dragenter', function (e) {
                    e.preventDefault();
                    $(this).addClass('drop-area-hover');
                })
                .on('dragover', function (e) {
                    e.preventDefault();
                    $(this).addClass('drop-area-hover');
                })
                .on('dragleave', function (e) {
                    $(this).removeClass('drop-area-hover');
                })
                .on('drop', function (e) {
                    e.stopPropagation();
                    e.preventDefault();
                    $(this).removeClass('drop-area-hover');
                    scope.OnDropTextarea(e);
                    debugger;
                });


            // utility functions
            scope.changeFolder = function (folderName) {
                scope.currentFolder = folderName;
                scope.showFolder = true;
            }
            scope.addFolder = function (folderName) {
                scope.folders.push(folderName);
                scope.currentFolder = folderName;
                scope.showFolder = true;
            }
            scope.hideFolder = function () {
                scope.currentFolder = ""
                scope.showFolder = false;
            }
            scope.toggleNewFilePop = function () {
                scope.NewFolderPop = !scope.NewFolderPop
                scope.NewFolderName = '';
            }
            scope.newFolderPopSave = function () {
                scope.addFolder(scope.NewFolderName);
                scope.toggleNewFilePop()
            }


            scope.addFiles = function (files) {
                for (var i = 0; i < files.length; i++) {
                    var file = files[i];
                    scope.$apply(function () {
                        if (scope.nameTable.indexOf(file.name) < 0) {
                            scope.files.push(file);
                            scope.nameTable.push(file.name);
                        }
                    });

                }
            }
            scope.removeChoosed = function (index) {
                scope.nameTable.splice(scope.nameTable.indexOf(scope.files[index].name), 1);
                scope.files.splice(index, 1);
            }
            scope.clearChoosed = function () {
                scope.nameTable = [];
                scope.files = [];
            }

            scope.showUpoading = function () {
                scope.uploadProcess = true;
                scope.dynamic = 1;
            }
            scope.hideUpoading = function () {
                scope.clearChoosed();
                scope.uploadProcess = false;
            }
            scope.showUploadErrors = function () {
                var error = _.some(scope.result, function (el) { return el.error });
                return !scope.uploading && error;
            }

            scope.OnDropTextarea = function (event) {
                if (event.originalEvent.dataTransfer) {
                    var files = event.originalEvent.dataTransfer.files;
                    scope.addFiles(files);
                }
                else {
                    alert("Your browser does not support the drag files.");
                }
            }
            scope.uploadFile = function () {
                scope.fileModel = scope.fileModel ? scope.fileModel : [];
                var targetFolder = (scope.baseFolder ? scope.baseFolder + '/' : '') + (scope.currentFolder ? scope.currentFolder + '/' : '')
                scope.result = [];      // final result will store here, but we build up it first for counting
                var len = scope.files.length;
                scope.showUpoading();
                scope.uploading = true;
                for (var i = 0; i < len; i++) {
                    var f = {};
                    f.name = ptFileService.getFileName(scope.files[i].name);
                    f.folder = scope.currentFolder;
                    f.uploadTime = new Date();
                    for (var j = 0; j < scope.columns.length; j++) {
                        var column = scope.columns[j];
                        f[column] = '';
                    }
                    scope.result.push(f);
                }

                for (var i = 0; i < len; i++) {
                    var data = new FormData();
                    data.append("file", scope.files[i]);
                    var targetName = ptFileService.getFileName(scope.files[i].name);
                    ptFileService.uploadFile(data, scope.fileBble, targetName, targetFolder, scope.uploadType, function (error, data, targetName) {
                        if (error) {
                            var targetElement = _.filter(scope.result, function (el) { return el.name == targetName })[0];
                            if (targetElement) targetElement.error = error;
                            scope.countCallback(len);
                        } else {
                            var targetElement = _.filter(scope.result, function (el) { return el.name == targetName })[0];
                            if (targetElement) {
                                targetElement.path = data[0];
                                if (data[1]) targetElement.thumb = data[1];
                            }
                            scope.fileModel.push(targetElement);
                            scope.countCallback(len);
                        }
                    });
                }

            }
            scope.count = 0;
            scope.countCallback = function (total) {
                if (scope.count >= total - 1) {
                    $timeout(function () {
                        scope.count = scope.count + 1;
                        scope.dynamic = Math.floor(scope.count / total * 100);
                        scope.count = 0;
                        scope.uploading = false;
                        scope.clearChoosed();
                    });
                } else {
                    $timeout(function () {
                        scope.count = scope.count + 1;
                        scope.dynamic = Math.floor(scope.count / total * 100);
                    })
                }
            }
            scope.modifyName = function (mdl, indx) {
                if (mdl[indx]) {
                    scope.ModifyNamePop = true;
                    scope.NewFileName = mdl[indx].name ? mdl[indx].name : '';
                    scope.editingFileModel = mdl;
                    scope.editingIndx = indx;
                    scope.editingFileExt = ptFileService.getFileExt(scope.NewFileName);
                }

            }
            scope.onModifyNamePopClose = function () {
                scope.NewFileName = '';
                scope.editingFileModel = null;
                scope.editingIndx = null;
                scope.ModifyNamePop = false;
                scope.editingFileExt = '';
            }
            scope.onModifyNamePopSave = function () {
                if (scope.NewFileName) {
                    if (scope.NewFileName.indexOf('.') > -1) {
                        scope.editingFileModel[scope.editingIndx].name = scope.NewFileName;
                    } else {
                        scope.editingFileModel[scope.editingIndx].name = scope.NewFileName + '.' + scope.editingFileExt;
                    }
                }
                scope.editingFileModel = null;
                scope.editingIndx = null;
                scope.ModifyNamePop = false;
                scope.editingFileExt = '';
            }
            scope.getThumb = function (model) {
                if (model && model.thumb) {
                    return ptFileService.getThumb(model.thumb);
                } else {
                    return '/images/no_image.jpg';
                }

            }
            scope.fancyPreview = function (file) {
                if (ptFileService.isPicture(file.name)) {
                    $.fancybox.open(ptFileService.makePreviewUrl(file.path));
                }
            }
            scope.filterError = function (v, i) {
                return v.error;
            }

        }

    }

}]).
directive('ptLink', ['ptFileService', function (ptFileService) {
    return {
        restrict: 'E',
        scope: {
            ptModel: '='
        },
        template: '<a ng-click="onFilePreview(ptModel.path)">{{trunc(ptModel.name,20)}}</a>',
        link: function (scope, el, attrs) {
            scope.onFilePreview = ptFileService.onFilePreview;
            scope.trunc = ptFileService.trunc;
        }

    }
}]).
directive('ptFinishedMark', [function () {
    return {
        restrict: 'E',
        template: '<span ng-if="ssStyle==0">'
                + '<button type="button" class="btn btn-default" ng-show="!ssModel" ng-click="confirm()">{{text1?text1:"Confirm"}}</button>'
                + '<button type="button" class="btn btn-success" ng-show="ssModel" ng-dblclick="deconfirm()">{{text2?text2:"Complete"}}&nbsp<i class="fa fa-check-circle"></i></button>'
                + '</span>'
                + '<span ng-if="ssStyle==1">'
                + '<span class="label label-default" ng-show="!ssModel" ng-click="confirm()">{{text1?text1:"Confirm"}}</span>'
                + '<span class="label label-success" ng-show="ssModel" ng-dblclick="deconfirm()">{{text2?text2:"Complete"}}&nbsp<i class="fa fa-check-circle"></i></span>'
                + '</span>',
        scope: {
            ssModel: '=',
            text1: '@',
            text2: '@',
            ssStyle: '@'
        },
        link: function (scope, el, attrs) {
            if (!scope.ssModel) scope.ssModel = false;
            if (scope.ssStyle && scope.ssStyle.toLowerCase() == 'label') {
                scope.ssStyle = 1;
            } else {
                scope.ssStyle = 0;
            }
            scope.confirm = function () {
                scope.ssModel = true;
            }
            scope.deconfirm = function () {
                scope.ssModel = false;
            }
        }
    }
}])
angular.module("PortalApp")
.controller('BuyerEntityCtrl', ['$scope', '$http', 'ptContactServices', function ($scope, $http, ptContactServices) {
    $scope.EmailTo = [];
    $scope.EmailCC = [];
    $scope.ptContactServices = ptContactServices;
    $scope.selectType = 'All Entities'
    $scope.Groups = [{ GroupName: 'All Entities' }, { GroupName: 'Available' }, { GroupName: 'Assigned Out' },
        {
            GroupName: 'Current Offer',
            SubGroups:
                [{ GroupName: 'NHA Current Offer' }, { GroupName: 'Isabel Current Offer' },
                { GroupName: 'Quiet Title Action' }, { GroupName: 'Deed Purchase' },
                { GroupName: 'Straight Sale' }, { GroupName: 'Jay Current Offer' }
                ]
        },

        {
            GroupName: 'Sold',
            SubGroups: [{ GroupName: 'Purchased' }, { GroupName: 'Partnered' },
                { GroupName: 'Sold (Final Sale)/Recyclable' }]
        },
        { GroupName: 'In House' }, { GroupName: 'Agent Corps' }]
    $scope.ChangeGroups = function (name) {
        $scope.selectType = name;
    }
    $scope.GetTitle = function () {
        return ($scope.SelectedTeam ? ($scope.SelectedTeam == '' ? 'All Team\'s ' : $scope.SelectedTeam + '\'s ') : '') + $scope.selectType;
    }
    $scope.ExportExcel = function () {
        JSONToCSVConvertor($scope.filteredCorps, true, $scope.GetTitle());

    }
    $scope.loadPanelVisible = true;
    $http.get('/Services/ContactService.svc/GetAllBuyerEntities').success(function (data, status, headers, config) {
        $scope.CorpEntites = data;
        $scope.currentContact = $scope.CorpEntites[0];
        $scope.loadPanelVisible = false;
    }).error(function (data, status, headers, config) {
        alert('Get All buyers Entities error : ' + JSON.stringify(data))
    });

    $http.get('/Services/TeamService.svc/GetAllTeam').success(function (data, status, headers, config) {
        $scope.AllTeam = data;

    }).error(function (data, status, headers, config) {
        alert('Get All Team name  error : ' + JSON.stringify(data))
    });

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
        $scope.currentContact = contact
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
    //for view and upload document -- add by chris
    $scope.encodeURIComponent = window.encodeURIComponent;

    $scope.UploadFile = function (fileUploadId, type, field) {
        $scope.loadPanelVisible = true;

        var contact = $scope.currentContact;
        var entityId = contact.EntityId;

        // grab file object from a file input
        var fileData = document.getElementById(fileUploadId).files[0];

        //$http.post('/services/ContactService.svc/UploadFile?id=' + entityId + '&type=' + type, fileData).success(function (data, status, headers, config) {
        //    $scope.currentContact.EINFile = data;
        //    //$scope = data;
        //    alert('successful..');                   
        //}).error(function (data, status, headers, config) {
        //    alert('error : ' + JSON.stringify(data))
        //});


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
angular.module('PortalApp')
.controller('ConstructionCtrl', ['$scope', '$http', '$interpolate', 'ptCom', 'ptContactServices', 'ptEntityService', 'ptShortsSaleService', 'ptLeadsService', 'ptConstructionService', function ($scope, $http, $interpolate, ptCom, ptContactServices, ptEntityService, ptShortsSaleService, ptLeadsService, ptConstructionService) {

    $scope._ = _;
    $scope.arrayRemove = ptCom.arrayRemove;
    $scope.ptContactServices = ptContactServices;
    $scope.ensurePush = function (modelName, data) { ptCom.ensurePush($scope, modelName, data); }

    $scope.CSCaseModel = function () {
        this.CSCase = {
            InitialIntake: {},
            Photos: {},
            Utilities: {
                Company: [],
                Insurance_Type: []
            },
            Violations: {
                DOBViolations: [],
                ECBViolations: []
            },
            ProposalBids: {},
            Plans: {},
            Contract: {},
            Signoffs: {},
            Comments: []
        }
    }
    $scope.PercentageModel = function () {
        this.intake = {
            count: 0,
            finished: 0,
        };
        this.signoff = {
            count: 0,
            finished: 0
        };
        this.construction = {
            count: 0,
            finished: 0
        };
        this.test = {
            count: 0,
            finished: 0
        }
    }

    // scope variables defination
    $scope.ReloadedData = {}
    $scope.CSCase = new $scope.CSCaseModel();
    $scope.percentage = new $scope.PercentageModel();

    $scope.UTILITY_SHOWN = {
        'ConED': 'CSCase.CSCase.Utilities.ConED_Shown',
        'Energy Service': 'CSCase.CSCase.Utilities.EnergyService_Shown',
        'National Grid': 'CSCase.CSCase.Utilities.NationalGrid_Shown',
        'DEP': 'CSCase.CSCase.Utilities.DEP_Shown',
        'MISSING Water Meter': 'CSCase.CSCase.Utilities.MissingMeter_Shown',
        'Taxes': 'CSCase.CSCase.Utilities.Taxes_Shown',
        'ADT': 'CSCase.CSCase.Utilities.ADT_Shown',
        'Insurance': 'CSCase.CSCase.Utilities.Insurance_Shown',
    };
    $scope.HIGHLIGHTS = [
                            { message: 'Plumbing signed off at {{CSCase.CSCase.Signoffs.Plumbing_SignedOffDate}}', criteria: 'CSCase.CSCase.Signoffs.Plumbing_SignedOffDate' },
                            { message: 'Electrical signed off at {{CSCase.CSCase.Signoffs.Electrical_SignedOffDate}}', criteria: 'CSCase.CSCase.Signoffs.Electrical_SignedOffDate' },
                            { message: 'Construction signed off at {{CSCase.CSCase.Signoffs.Construction_SignedOffDate}}', criteria: 'CSCase.CSCase.Signoffs.Construction_SignedOffDate' },
                            { message: 'HPD Violations has all finished', criteria: 'CSCase.CSCase.Violations.HPD_OpenHPDViolation === false' }
    ];
    $scope.WATCHED_MODEL = [
                                {
                                    model: 'CSCase.CSCase.Signoffs.Plumbing_SignedOffDate',
                                    backedModel: 'ReloadedData.Backed_Plumbing_SignedOffDate',
                                    info: 'Plumbing Sign Off Date'
                                },
                                {
                                    model: 'CSCase.CSCase.Signoffs.Construction_SignedOffDate',
                                    backedModel: 'ReloadedData.Backed_Construction_SignedOffDate',
                                    info: 'Construction Sign Off Date'
                                },
                                {
                                    model: 'CSCase.CSCase.Signoffs.Electrical_SignedOffDate',
                                    backedModel: 'ReloadedData.Electrical_SignedOffDate',
                                    info: 'Electrical Sign Off Date'
                                }];

    // end scope variables defination

    $scope.reload = function () {
        $scope.ReloadedData = {};
        $scope.CSCase = new $scope.CSCaseModel();
        $scope.ensurePush('CSCase.CSCase.Utilities.Floors', { FloorNum: '?', ConED: {}, EnergyService: {}, NationalGrid: {} });
        $scope.percentage = new $scope.PercentageModel();
        $scope.clearWarning();
    }

    $scope.init = function (bble, callback) {
        ptCom.startLoading();
        bble = bble.trim();
        $scope.reload();
        var done1, done2, done3, done4;

        ptConstructionService.getConstructionCases(bble, function (res) {
            ptCom.nullToUndefined(res);
            $.extend(true, $scope.CSCase, res);
            $scope.initWatchedModel();
            done1 = true;
            if (done1 && done2 && done3 & done4) {
                ptCom.stopLoading();
                if (callback) callback();
            }

        });
        ptShortsSaleService.getShortSaleCaseByBBLE(bble, function (res) {
            $scope.SsCase = res;
            done2 = true;
            if (done1 && done2 && done3 & done4) {
                ptCom.stopLoading();
                if (callback) callback();
            }

        });
        ptLeadsService.getLeadsByBBLE(bble, function (res) {
            $scope.LeadsInfo = res;
            done3 = true;
            if (done1 && done2 && done3 & done4) {
                ptCom.stopLoading();
                if (callback) callback();
            }
        });
        ptEntityService.getEntityByBBLE(bble, function (error, data) {
            if (data) {
                $scope.EntityInfo = data;
            } else {
                $scope.EntityInfo = {};
                console.log(error);
            }
            done4 = true;
            if (done1 && done2 && done3 & done4) {
                ptCom.stopLoading();
                if (callback) callback();
            }
        })

    }

    /* Status change function -- Chris */
    $scope.ChangeStatus = function (scuessfunc, status) {
        $http.post('/api/ConstructionCases/ChangeStatus/' + leadsInfoBBLE, status)
            .success(function () {
                if (scuessfunc) {
                    scuessfunc();
                } else {
                    ptCom.alert("Successed !");
                }
            }).error(function (data, status) {
                ptCom.alert("Fail to save data. status " + status + "Error : " + JSON.stringify(data));
            });
    }
    /* end status change function */

    $scope.saveCSCase = function () {
        var data = angular.toJson($scope.CSCase);
        ptConstructionService.saveConstructionCases($scope.CSCase.BBLE, data, function (res) {
            ScopeSetLastUpdateTime($scope.GetTimeUrl());
            ptCom.alert("Save successfully!");
        });
        $scope.updateInitialFormOwner();
        $scope.checkWatchedModel();
    }


    /* multiple company selection */
    $scope.$watch('CSCase.CSCase.Utilities.Company', function (newValue) {
        if (newValue) {
            var ds = $scope.UTILITY_SHOWN;
            var target = $scope.CSCase.CSCase.Utilities.Company;
            _.each(target, function (k, i) {
                $scope.$eval(ds[k] + '=false');
            })
            _.each(newValue, function (el, i) {
                $scope.$eval(ds[el] + '=true');
            })
        }
    }, true);

    $scope.$watch('CSCase.CSCase.Utilities.ConED_EnergyServiceRequired', function (newVal) {

        if (newVal) {
            if ($scope.CSCase.CSCase.Utilities.Company.indexOf('Energy Service') < 0) {
                $scope.CSCase.CSCase.Utilities.Company.push('Energy Service');
                $scope.ReloadedData.EnergyService_Collapsed = false;
            }
        } else {
            var index = $scope.CSCase.CSCase.Utilities.Company.indexOf('Energy Service');
            if (index !== -1) $scope.CSCase.CSCase.Utilities.Company.splice(index, 1);
        }


    });
    /* end multiple company selection */

    /* reminder */
    $scope.sendNotice = function (id, name) {
        confirm("Send Intake Sheet To " + name + " ?");
    }
    /* end reminder */

    /* comments */
    $scope.showPopover = function (e) {
        aspxConstructionCommentsPopover.ShowAtElement(e.target);
    }
    $scope.addComment = function (comment) {
        var newComments = {}
        newComments.comment = comment;
        newComments.caseId = $scope.CaseId;
        newComments.createBy = Current_User;
        newComments.createDate = new Date();
        $scope.CSCase.CSCase.Comments.push(newComments);
    }
    $scope.addCommentFromPopup = function () {
        var comment = $scope.addCommentTxt;
        $scope.addComment(comment);
        $scope.addCommentTxt = '';
    }
    /* end comments */

    /* active tab */
    $scope.activeTab = 'CSInitialIntake';
    $scope.updateActive = function (id) {
        $scope.activeTab = id;
    }
    /* end active tab */

    /* highlight */

    $scope.isHighlight = function (criteria) {
        return $scope.$eval(criteria);
    }
    $scope.highlightMsg = function (msg) {
        var msgstr = $interpolate(msg)($scope);
        return msgstr;
    }

    $scope.initWatchedModel = function () {
        _.each($scope.WATCHED_MODEL, function (el, i) {
            $scope.$eval(el.backedModel + '=' + el.model);
        })
    }
    $scope.checkWatchedModel = function () {
        var res = '';
        _.each($scope.WATCHED_MODEL, function (el, i) {
            if ($scope.$eval(el.backedModel + '!=' + el.model)) {
                $scope.$eval(el.backedModel + '=' + el.model);
                res += (el.info + ' changes to ' + $scope.$eval(el.model) + '.<br>')
            }
        })
        if (res) AddActivityLog(res);
    }

    /* end highlight */

    /* Popup */
    $scope.setPopupVisible = function (modelName, bVal) {
        $scope.$eval(modelName + '=' + bVal);
    }
    /* end Popup*/

    /* header editing */
    $scope.HeaderEditing = false;
    $scope.toggleHeaderEditing = function (open) {
        $scope.HeaderEditing = !$scope.HeaderEditing;
        if (open) $("#ConstructionTitleInput").focus();
    }
    /* end header editing */

    /* dob fetch */
    $scope.addNewDOBViolation = function () {
        $scope.ensurePush('CSCase.CSCase.Violations.DOBViolations');
        $scope.setPopupVisible('ReloadedData.DOBViolations_PopupVisible_' + ($scope.CSCase.CSCase.Violations.DOBViolations.length - 1), true);
    }
    $scope.addNewECBViolation = function () {
        $scope.ensurePush('CSCase.CSCase.Violations.ECBViolations');
        $scope.setPopupVisible('ReloadedData.ECBViolations_PopupVisible_' + ($scope.CSCase.CSCase.Violations.ECBViolations.length - 1), true);
    }
    $scope.fetchDOBViolations = function () {
        ptCom.confirm("<h3 style='color:red'>Warning!!!</h3>Getting information from DOB takes a while.<br>And it will <b>REPLACE</b> your current Data, are you sure to continue?", "Warning")
        .then(function (confirmed) {
            if (confirmed) {
                ptConstructionService.getDOBViolations($scope.CSCase.BBLE, function (error, res) {
                    if (error) {
                        ptCom.alert(error);
                        console.log(error)
                    } else {
                        ptCom.confirm("<h3 style='color:red'>Warning!!!</h3>Your current DOB Violation data will be replaced.", "Warning")
                        .then(function (confirmed) {
                            if (confirmed) {

                                if (res && res.DOB_TotalDOBViolation) $scope.CSCase.CSCase.Violations.DOB_TotalDOBViolation = res.DOB_TotalDOBViolation;
                                if (res && res.DOB_TotalOpenViolations) $scope.CSCase.CSCase.Violations.DOB_TotalOpenViolations = res.DOB_TotalOpenViolations;
                                if (res && res.violations) $scope.CSCase.CSCase.Violations.DOBViolations = res.violations;

                            }
                        })

                    }
                })
            }

        })

    }
    $scope.fetchECBViolations = function () {
        ptCom.confirm("<h3 style='color:red'>Warning!!!</h3>Getting information from DOB takes a while.<br>And it will <b>REPLACE</b> your current Data, are you sure to continue?", "Warning")
        .then(function (confirmed) {
            if (confirmed) {
                ptConstructionService.getECBViolations($scope.CSCase.BBLE, function (error, res) {
                    if (error) {
                        ptCom.alert(error);
                        console.log(error)
                    } else {
                        ptCom.confirm("<h3 style='color:red'>Warning!!!</h3>Your current DOB Violation data will be replaced.", "Warning")
                        .then(function (confirmed) {
                            if (confirmed) {
                                if (res && res.ECP_TotalViolation) $scope.CSCase.CSCase.Violations.ECP_TotalViolation = res.ECP_TotalViolation;
                                if (res && res.ECP_TotalOpenViolations) $scope.CSCase.CSCase.Violations.ECP_TotalOpenViolations = res.ECP_TotalOpenViolations;
                                if (res && res.violations) {
                                    $scope.CSCase.CSCase.Violations.ECBViolations = _.filter(res.violations, function (el, i) {
                                        return el.DOBViolationStatus.slice(0, 4) == "OPEN"
                                    });
                                }
                            }
                        })

                    }
                })
            }

        })
    }
    /* end dob fetch */

    /* intakeComplete */
    $scope.test = $scope.checkIntake;
    $scope.intakeComplete = function () {
        if (!$scope.checkIntake(function (el) {
            el.prev().css('background-color', 'yellow')
        })) {
            $scope.CSCase.IntakeCompleted = true;
            AddActivityLog("Intake Process have finished!");
            $scope.saveCSCase();
        } else {
            ptCom.alert("Intake Complete Fails.\nPlease check highlights for missing information!");
        }
    }
    $scope.checkIntake = function (callback) {
        $scope.clearWarning();
        $scope.percentage.intake.count = 0;
        $scope.percentage.intake.finished = 0;
        $(".intakeCheck").each(function (idx) {
            var test;
            var model = $(this).attr('ng-model') || $(this).attr('ss-model') || $(this).attr('file-model') || $(this).attr('model');
            if (model) {
                if (model.slice(0, 4) === "floor") {
                    test = _.has($(this).scope().floor, model.split(".").splice(1).join('.'));
                    if (!test) {
                        if (callback) callback($(this))
                    } else {
                        $scope.percentage.intake.finished++;
                    }
                } else {
                    test = $scope.$eval(model)
                    if (test === undefined) {
                        if (callback) callback($(this))
                    } else {
                        $scope.percentage.intake.finished++;
                    }
                }
            }
            $scope.percentage.intake.count++;
        })
        var errors = $scope.percentage.intake.count - $scope.percentage.intake.finished;
        return errors;
    }
    $scope.clearWarning = function () {
        $(".intakeCheck").each(function (idx) {
            $(this).prev().css('background-color', 'transparent');
        });
    }
    $scope.updatePercentage = function () {
        $scope.checkIntake();
    }
    /* end intakeComplte */

    /*check file be modify*/
    $scope.GetTimeUrl = function () {
        return $scope.CSCase.BBLE ? "/api/ConstructionCases/LastLastUpdate/" + $scope.CSCase.BBLE : "";
    }
    $scope.GetCSCaseId = function () {
        return $scope.CSCase.BBLE;
    }
    $scope.GetModifyUserUrl = function () {
        return "/api/ConstructionCases/LastModifyUser/" + $scope.CSCase.BBLE;
    }

    /****** end check file be modify*********/

    /* printWindows*/
    $scope.printWindow = function () {
        window.open("/Construction/ConstructionPrint.aspx?bble=" + $scope.CSCase.BBLE, 'Print', 'width=1024, height=800');
    }
    /* end printWindows */

    $scope.openInitialForm = function () {
        window.open("/Construction/ConstructionInitialForm.aspx?bble=" + $scope.CSCase.BBLE, 'Initial Form', 'width=1280, height=960')
    }

    $scope.openBudgetForm = function () {
        window.open("/Construction/ConstructionBudgetForm.aspx?bble=" + $scope.CSCase.BBLE, 'Budget Form', 'width=1024, height=768')
    }

    $scope.getRunnerList = function () {
        var url = "/api/ConstructionCases/GetRunners";
        $http.get(url)
        .then(function (res) {
            if (res.data) {
                $scope.RUNNER_LIST = res.data;
            }
        })
    }();

    $scope.updateInitialFormOwner = function () {
        var url = "/api/ConstructionCases/UpdateInitialFormOwner?BBLE=" + $scope.CSCase.BBLE + "&owner=" + $scope.CSCase.CSCase.InitialIntake.InitialFormAssign
        $http({
            method: 'POST',
            url: url
        }).then(function success(res) {
            console.log("Assign Initial Form owner Success.")
        }, function error(res) {
            console.log("Fail to assign Initial Form owner.")
        })
    }

    $scope.getOrdersLength = function () {

    }
}]
);
angular.module('PortalApp')
.controller("ReportWizardCtrl", function ($scope, $http, $timeout, ptCom) {
    $scope.camel = _.camelCase;

    $scope.step = 1;
    $scope.collpsed = [];
    $scope.CurrentQuery = null;
    $scope.reload = function (callback) {
        $scope.step = 1;
        $scope.CurrentQuery = null;
        $http.get(CUSTOM_REPORT_TEMPLATE)
            .then(function (res) {
                $scope.Fields = res.data[0].Fields;
                $scope.BaseTable = res.data[0].BaseTable;
                $scope.IncludeAppId = res.data[0].IncludeAppId;
                if (callback) callback();
            });
        $scope.loadSavedReport();
    };
    $scope.loadSavedReport = function () {
        $http.get("/api/Report/Load")
            .then(function (res) {
                $scope.SavedReports = res.data;
            });
    };
    $scope.deleteSavedReport = function (q) {
        var _confirm = confirm("Are you sure to delete?");
        if (_confirm) {
            if (q.ReportId) {
                $http({
                    method: "DELETE",
                    url: "/api/Report/Delete/" + q.ReportId,
                }).then(function (res) {
                    $scope.reload();
                    alert("Delete Success.");
                });
            } else {
                alert("Delete Fails!");
            }
        }

    }; // load saved query
    $scope.load = function (q) {
        $scope.reload(
            function () {
                if (q.ReportId) {
                    $http.get("/api/Report/Load/" + q.ReportId)
                    .then(function (res) {
                        var data = res.data;
                        $scope.CurrentQuery = data;
                        $scope.Fields = JSON.parse(data.Query);
                        $scope.generate();

                        var gridState = JSON.parse(data.Layout);
                        $("#queryReport").dxDataGrid("instance").state(gridState);
                    });
                }
            }
        );
    };
    $scope.someCheck = function (category) {
        return _.some(category.fields, { checked: true });
    };
    $scope.addFilter = function (f) {
        if (!f.filters) f.filters = [];
        f.filters.push({});
    };
    $scope.removeFilter = function (f, i) {
        f.filters.splice(i, 1);
    };
    $scope.updateStringFilter = function (x) {
        if (!x.criteria || !x.input1) {
            x.WhereTerm = "";
            x.CompareOperator = "";
            x.value1 = "";
            return;
        } else {
            switch (x.criteria) {
                case "1":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Like";
                    x.value1 = x.input1.trim() + "%";
                    break;
                case "2":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Like";
                    x.value1 = "%" + x.input1.trim();
                    break;
                case "3":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Like";
                    x.value1 = "%" + x.input1.trim() + "%";
                    break;
                default:
                    x.WhereTerm = "";
                    x.CompareOperator = "";
                    x.value1 = "";
            }
        }
    };
    $scope.updateDateFilter = function (x) {
        if (!x.criteria || !x.input1) {
            x.WhereTerm = "";
            x.CompareOperator = "";
            x.value1 = "";
            return;
        } else {
            switch (x.criteria) {
                case "1":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Less";
                    x.value1 = x.input1;
                    break;
                case "2":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Greater";
                    x.value1 = x.input1;
                    break;
                case "3":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Equal";
                    x.value1 = x.input1;
                    break;
                default:
                    x.WhereTerm = "";
                    x.CompareOperator = "";
                    x.value1 = "";
            }
        }

    };
    $scope.updateNumberFilter = function (x) {

        if (!x.criteria || !x.input1 || (x.criteria == "5" && !x.input2)) {
            x.WhereTerm = "";
            x.CompareOperator = "";
            x.value1 = "";
            x.value2 = "";
            return;
        } else {
            switch (x.criteria) {
                case "1":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Less";
                    x.value1 = x.input1.trim();
                    x.value2 = "";
                    break;
                case "2":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "LessOrEqual";
                    x.value1 = x.input1.trim();
                    x.value2 = "";
                    break;
                case "3":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Greater";
                    x.value1 = x.input1.trim();
                    x.value2 = "";
                    break;
                case "4":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "GreaterOrEqual";
                    x.value1 = x.input1.trim();
                    x.value2 = "";
                    break;
                case "5":
                    x.WhereTerm = "CreateBetween";
                    x.CompareOperator = "";
                    x.value1 = x.input1.trim();
                    x.value2 = x.input2.trim();
                    break;
                default:
                    x.WhereTerm = "";
                    x.CompareOperator = "";
                    x.value1 = "";
                    x.value2 = "";
            }
        }
    };
    $scope.updateListFilter = function (x) {
        if (!x.input1 || x.input1.length < 1) {
            x.WhereTerm = "";
            x.CompareOperator = "";
            x.value1 = "";
        } else {
            x.WhereTerm = "CreateIn";
            x.CompareOperator = "";
            x.value1 = x.input1;
        }
    };    
    $scope.updateBooleanFilter = function (x) {
        if (!x.input1) {
            x.WhereTerm = "";
            x.CompareOperator = "";
            x.value1 = "";
        } else {
            switch (x.input1) {
                case "1":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Equal";
                    x.value1 = true;
                    break;
                case "0":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Equal";
                    x.value1 = false;
                    break;
                default:
                    x.WhereTerm = "";
                    x.CompareOperator = "";
                    x.value1 = "";
            }
        }
    };

    $scope.onSaveQueryPopCancel = function () {
        $scope.NewQueryName = '';
        $scope.SaveQueryPop = false;
    };
    $scope.onSaveQueryPopSave = function () {
        if (!$scope.NewQueryName) {
            alert("New query name is empty!");
            $scope.NewQueryName = '';
            $scope.SaveQueryPop = false;
        } else {

            var data = {};

            data.Name = $scope.NewQueryName;

            data.Query = JSON.stringify($scope.Fields);
            data.sqlText = $scope.sqlText;
            data.Layout = JSON.stringify($("#queryReport").dxDataGrid("instance").state());

            data = JSON.stringify(data);

            $http({
                method: "POST",
                url: "/api/Report/Save",
                data: data,
            }).then(function (res) {
                $scope.NewQueryName = '';
                $scope.SaveQueryPop = false;
                $scope.reload();
                alert("Save successful!");
            });
        }
    };

    $scope.update = function () {

        var data = $scope.CurrentQuery;

        data.Query = JSON.stringify($scope.Fields);
        data.sqlText = $scope.sqlText;
        data.Layout = JSON.stringify($("#queryReport").dxDataGrid("instance").state());

        data = JSON.stringify(data);

        $http({
            method: "POST",
            url: "/api/Report/Save",
            data: data,
        }).then(function (res) {
            $scope.NewQueryName = '';
            $scope.SaveQueryPop = false;
            $scope.reload();
            alert("Save successful!");
        });
    };
    $scope.isBindColumn = function (f) {

        if (!f.table || !f.column) {
            return false;
        } else {
            return true;
        }
    };
    $scope.next = function () {
        $scope.step = $scope.step + 1;
    };
    $scope.prev = function () {
        $scope.step = $scope.step - 1;
    };
    $scope.filterDate = function (model) {
        var dtPatn = /\d{4}-\d{2}-\d{2}/;
        if (model) {
            _.each(model, function (el, idx) {
                if (el) {
                    _.forOwn(el, function (v, k) {
                        if (v && typeof (v) === 'string' && v.match(dtPatn)) {
                            el[k] = ptCom.toUTCLocaleDateString(v);
                        }
                    });
                }

            });
        }
    };
    $scope.generate = function () {
        var result = [];
        var BaseTable = $scope.BaseTable ? $scope.BaseTable : '';
        var IncludeAppId = $scope.IncludeAppId ? $scope.IncludeAppId : '';
        _.each($scope.Fields, function (el, i) {
            _.each(el.fields, function (el, i) {
                if (el.checked) {
                    result.push(el);
                }
            });
        });
        if (result.length > 0) {
            $scope.step = 3;
            $http({
                method: "POST",
                url: "/api/Report/QueryData?baseTable=" + BaseTable + "&includeAppId=" + IncludeAppId,
                data: JSON.stringify(result),
            }).then(function (res) {
                var rdata = res.data[0];
                $scope.filterDate(rdata);
                $scope.reportData = rdata;
                $scope.sqlText = res.data[1];
            });
        } else {
            alert("Query is empty!");
        }
    };
    $scope.reload();
});
angular.module("PortalApp")
.controller('ShortSaleCtrl', ['$scope', '$http', '$timeout', 'ptContactServices', 'ptCom', function ($scope, $http, $timeout, ptContactServices, ptCom) {

    $scope.ptContactServices = ptContactServices;
    $scope.capitalizeFirstLetter = ptCom.capitalizeFirstLetter;
    $scope.formatName = ptCom.formatName;
    $scope.formatAddr = ptCom.formatAddr;
    $scope.ptCom = ptCom;

    $scope.SsCase = {
        PropertyInfo: { Owners: [{}] },
        CaseData: {},
        Mortgages: [{}]
    };
    $scope.SsCaseApprovalChecklist = {};
    $scope.Approval_popupVisible = false;
    $http.get('/Services/ContactService.svc/getbanklist').success(function (data) {
        $scope.bankNameOptions = data;
    }).error(function (data) {
        $scope.bankNameOptions = [];
    });

    //move to construction - add by chris
    $scope.MoveToConstruction = function (scuessfunc) {
        var json = $scope.SsCase;
        var data = { bble: leadsInfoBBLE };

        $http.post('ShortSaleServices.svc/MoveToConstruction', JSON.stringify(data))
            .success(function () {
                if (scuessfunc) {
                    scuessfunc();
                } else {
                    ptCom.alert("Move to Construction successful!");
                }
            }).error(function (data1, status) {
                ptCom.alert("Fail to save data. status :" + status + "Error : " + JSON.stringify(data1));
            });
    };

    $scope.MoveToTitle = function (scuessfunc) {
        var json = $scope.SsCase;
        var data = { bble: leadsInfoBBLE };

        $http.post('ShortSaleServices.svc/MoveToTitle', JSON.stringify(data))
            .success(function () {
                if (scuessfunc) {
                    scuessfunc();
                } else {
                    ptCom.alert("Move to Title successful !");
                }
            }).error(function (data1, status) {
                ptCom.alert("Fail to save data. status " + status + "Error : " + JSON.stringify(data1));
            });
    }; // -- end --


    $scope.GetShortSaleCase = function (caseId, callback) {
        if (!caseId) {
            console.log("Can not find case Id ");
            return;
        }

        ptCom.startLoading();
        var done1, done2;
        $http.get("ShortSaleServices.svc/GetCase?caseId=" + caseId)
            .success(function (data) {
                $scope.SsCase = data;
                leadsInfoBBLE = $scope.SsCase.BBLE;
                window.caseId = caseId;

                $http.get("ShortSaleServices.svc/GetLeadsInfo?bble=" + $scope.SsCase.BBLE).success(function (data1) {
                    $scope.ReloadedData = {};
                    $scope.SsCase.LeadsInfo = data1;
                    $('#CaseData').val(JSON.stringify($scope.SsCase));
                    if (callback) { callback(); }
                    done1 = true;
                    if (done1 && done2) {
                        ptCom.stopLoading();
                    }

                }).error(function (data1) {
                    ptCom.stopLoading();
                    ptCom.alert("Get Short sale Leads failed BBLE =" + $scope.SsCase.BBLE + " error : " + JSON.stringify(data1));
                });

                $http.get('/LegalUI/LegalServices.svc/GetLegalCase?bble=' + leadsInfoBBLE).success(function (data1) {
                    $scope.LegalCase = data1;
                    done2 = true;
                    if (done1 && done2) {
                        ptCom.stopLoading();
                    }
                }).error(function (data1) {
                    ptCom.stopLoading();
                    console.log("Fail to load data : " + leadsInfoBBLE + " :" + JSON.stringify(data1)); // alert("Fail to load data : " + leadsInfoBBLE + " :" + 
                });
            }).error(function (data) {
                ptCom.stopLoading();
                ptCom.alert("Get Short sale failed CaseId= " + caseId + ", error : " + JSON.stringify(data));
            });
    };
    $scope.GetLoadId = function () {
        return window.caseId;
    };
    $scope.GetModifyUserUrl = function () {
        return 'ShortSaleServices.svc/GetModifyUserUrl?caseId=' + window.caseId;
    };

    $scope.NGAddArraryItem = function (item, model, popup) {
        if (model) {
            var array = $scope.$eval(model);
            if (!array) { $scope.$eval(model + '=[{}]'); }
            else { $scope.$eval(model + '.push({})'); }
        } else { item.push({}); }
        if (popup) { $scope.setVisiblePopup(item[item.length - 1], true); }

    };
    $scope.NGremoveArrayItem = function (item, index, disable) {
        var r = window.confirm("Delete This?");
        if (r) {
            if (disable) item[index].DataStatus = 3;
            else item.splice(index, 1);
        }

    };

    $scope.SaveShortSale = function (callback) {
        var json = $scope.SsCase;
        var data = { caseData: JSON.stringify(json) };

        $http.post('ShortSaleServices.svc/SaveCase', JSON.stringify(data)).
                success(function () {
                    // if save scuessed load data again 

                    $scope.GetShortSaleCase($scope.SsCase.CaseId);
                    ptCom.alert("Save Successed !");
                    if (callback) { callback(); }

                }).error(function (data1, status) {
                    var message = (data1 && typeof data1 == 'object' && data1.message) ? data1.message : JSON.stringify(data1);
                    ptCom.alert("Fail to save data. status " + status + "Error : " + message);
                });
    };
    $scope.ShowAddPopUp = function (event) {
        $scope.addCommentTxt = "";
        aspxAddLeadsComments.ShowAtElement(event.target);
    };
    $scope.AddComments = function () {

        $http.post('ShortSaleServices.svc/AddComments', { comment: $scope.addCommentTxt, caseId: $scope.SsCase.CaseId }).success(function (data) {
            $scope.SsCase.Comments.push(data);
        }).error(function (data, status) {
            ptCom.alert("Fail to AddComments. status " + status + "Error : " + JSON.stringify(data));
        });

    };
    $scope.DeleteComments = function (index) {
        var comment = $scope.SsCase.Comments[index];
        $http.get('ShortSaleServices.svc/DeleteComment?commentId=' + comment.CommentId).success(function (data) {
            $scope.SsCase.Comments.splice(index, 1);
        }).error(function (data, status) {
            ptCom.alert("Fail to delete comment. status " + status + "Error : " + JSON.stringify(data));
        });
    };
    $scope.GetCaseInfo = function () {
        var CaseInfo = { Name: '', Address: '' };
        var caseName = $scope.SsCase.CaseName;
        if (caseName) {
            CaseInfo.Address = caseName.replace(/-(?!.*-).*$/, '');
            var matched = caseName.match(/-(?!.*-).*$/);
            if (matched && matched[0]) {
                CaseInfo.Name = matched[0].replace('-', '');
            }
        }
        return CaseInfo;
    };

    $scope.setVisiblePopup = function (model, value) {
        if (model) model.visiblePopup = value;
        _.defer(function () { $scope.$apply(); });

    };


    $scope.approvalSave = function () {
        if ($scope.approvalSuccCallback) $scope.approvalSuccCallback();
        $scope.SaveShortSale();
        $scope.Approval_popupVisible = false;
    };
    $scope.approvalCancl = function () {
        if ($scope.approvalCanclCallback) $scope.approvalCanclCallback();
        $scope.Approval_popupVisible = false;
    };
    $scope.regApproval = function (succ, cancl) {
        if (!$scope.approvalSuccCallback) $scope.approvalSuccCallback = succ;
        if (!$scope.approvalCanclCallback) $scope.approvalCanclCallback = cancl;
    };
    $scope.toggleApprovalPopup = function () {
        $scope.$apply(function () {
            $scope.Approval_popupVisible = !$scope.Approval_popupVisible;
        });
    }; /* end approval popup */

    /* valuation popup */
    $scope.ValuationWatchField = {
        Method: 'Type of Valuation',
        DateOfCall: 'Date of Call',
        AgentName: 'BPO Agent',
        AgentPhone: 'Agent Phone #',
        DateOfValue: 'Date of Valuation',
        TimeOfValuation: 'Time of Valuation',
        Access: 'Access',
        IsValuationComplete: 'Valuation Completed',
        DateComplate: 'Complete Date'
    };
    $scope.Valuation_popupVisible = false;
    $scope.Valuation_Show_Option = 1;
    $scope.addPendingValue = function () {
        $scope.SsCase.ValueInfoes.push({ Pending: true });
    };
    $scope.removePendingValue = function (el) {
        var index = $scope.SsCase.ValueInfoes.indexOf(el);
        $scope.NGremoveArrayItem($scope.SsCase.ValueInfoes, index);
    };
    $scope.ensurePendingValue = function () {
        var existPending = false;
        _.each($scope.SsCase.ValueInfoes, function (el, index) {
            if (el.Pending) existPending = true;
        });
        if (!existPending) $scope.addPendingValue();
    };
    $scope.setPendingModified = function () {
        $scope.oldPendingValues = [];
        _.each($scope.SsCase.ValueInfoes, function (el, index) {
            if (el.Pending) {
                var newEl = {};
                for (var property in el) {
                    if (el.hasOwnProperty(property)) {
                        newEl[property] = el[property];
                    }
                }
                $scope.oldPendingValues.push(newEl);
            }
        });
    };
    $scope.checkPendingModified = function () {
        var updates = '';
        _.each($scope.SsCase.ValueInfoes, function (el, index) {
            if (el.Pending) {
                var oldEl = $scope.oldPendingValues.filter(function (e, i) { return e.$$hashKey == el.$$hashKey })[0];
                if (!oldEl) {
                    for (var property in el) {
                        if ($scope.ValuationWatchField.hasOwnProperty(property)) {
                            updates += 'Valuation' + index + ' <b>' + $scope.ValuationWatchField[property] + '</b> changes to <b>' + el[property] + '</b><br/>';
                        }
                    }
                } else {
                    for (var property in el) {
                        if ($scope.ValuationWatchField[property] && el[property] !== oldEl[property]) {
                            updates += 'Valuation' + index + ' <b>' + $scope.ValuationWatchField[property] + '</b> changes to <b>' + el[property] + '</b><br/>';
                        }
                    }
                }

            }
        }); //console.log(updates)
        return updates;
    };
    $scope.restorePendingModified = function () {
        _.remove($scope.SsCase.ValueInfoes, function (el, index) {
            return el.Pending;
        });
        _.each($scope.oldPendingValues, function (el, index) {
            $scope.SsCase.ValueInfoes.push(el);
        });
    };
    $scope.valuationCanl = function () {
        $scope.restorePendingModified();
        if ($scope.valuationCanclCallback) $scope.valuationCanclCallback();
        $scope.Valuation_popupVisible = false;
    };
    $scope.valuationSave = function () {
        var updates = $scope.checkPendingModified();
        if ($scope.valuationSuccCallback) $scope.valuationSuccCallback(updates);
        $scope.Valuation_popupVisible = false;

    };
    $scope.valuationCompl = function (el) {
        var updates = $scope.checkPendingModified();
        if ($scope.valuationSuccCallback) $scope.valuationSuccCallback(updates);
        el.Pending = false;
        $scope.Valuation_popupVisible = false;
    };
    $scope.regValuation = function (succ, cancl) {
        if (!$scope.valuationSuccCallback) $scope.valuationSuccCallback = succ;
        if (!$scope.valuationCanclCallback) $scope.valuationCanclCallback = cancl;
    };
    $scope.toggleValuationPopup = function (status) {
        $scope.$apply(function () {
            $scope.Valuation_Show_Option = status;
            $scope.setPendingModified();
            $scope.ensurePendingValue();
            $scope.Valuation_popupVisible = !$scope.Valuation_popupVisible;
        });
    }; /* end valuation popup */

    /* update mortage status */
    $scope.UpdateMortgageStatus = function (selType1, selStatusUpdate, selCategory) {
        var index = 0;
        switch (selType1) {
            case '2nd Lien':
                index = 1;
                break;
            case '3d Lien':
                index = 2;
                break;
            default:
                index = 0;
        }

        $timeout(function () {
            if ($scope.SsCase.Mortgages[index]) {
                $scope.SsCase.Mortgages[index].Category = selCategory;
                $scope.SsCase.Mortgages[index].Status = selStatusUpdate;
            }

        });
    }; /* end update mortage status*/
}]);
angular.module("PortalApp")
.controller("TitleController", ['$scope', '$http', 'ptCom', 'ptContactServices', 'ptLeadsService', 'ptShortsSaleService', function ($scope, $http, ptCom, ptContactServices, ptLeadsService, ptShortsSaleService) {
    /* model define*/
    $scope.OwnerModel = function (name) {
        this.name = name;
        this.Mortgages = [{}];
        this.Lis_Pendens = [{}];
        this.Judgements = [{}];
        this.ECB_Notes = [{}];
        this.PVB_Notes = [{}];
        this.Bankruptcy_Notes = [{}];
        this.UCCs = [{}];
        this.FederalTaxLiens = [{}];
        this.MechanicsLiens = [{}];
        this.TaxLiensSaleCerts = [{}];
        this.VacateRelocationLiens = [{}];
        this.shownlist = [false, false, false, false, false, false, false, false, false, false, false];
    };
    $scope.FormModel = function () {
        this.FormData = {
            Comments: [],
            Owners: [new $scope.OwnerModel("Prior Owner Liens"), new $scope.OwnerModel("Current Owner Liens")],
            preclosing: {
                ApprovalData: [{}]
            },
            docs: {}
        };
    };

    $scope.StatusList = [
        {
            num: 0,
            desc: 'Initial Review'
        }, {
            num: 1,
            desc: 'Clearance'
        }
    ];
    $scope.arrayRemove = ptCom.arrayRemove;
    $scope.ptCom = ptCom;
    $scope.ptContactServices = ptContactServices;
    $scope.ensurePush = function (modelName, data) { ptCom.ensurePush($scope, modelName, data); };
    $scope.Form = new $scope.FormModel();
    $scope.ReloadedData = {};

    $scope.Load = function (data) {
        $scope.Form = new $scope.FormModel();
        $scope.ReloadedData = {};
        ptCom.nullToUndefined(data);
        $.extend(true, $scope.Form, data);
        if (!$scope.Form.FormData.Owners[0].shownlist) {
            $scope.Form.FormData.Owners[0].shownlist = [false, false, false, false, false, false, false, false, false, false, false];
            $scope.Form.FormData.Owners[1].shownlist = [false, false, false, false, false, false, false, false, false, false, false];
        }
        $scope.BBLE = data.Tag;
        if ($scope.BBLE) {
            ptLeadsService.getLeadsByBBLE($scope.BBLE, function (res) {
                $scope.LeadsInfo = res;
            });
            ptShortsSaleService.getBuyerTitle($scope.BBLE, function (error, res) {
                if (error) console.log(error);
                if (res) $scope.BuyerTitle = res.data;
            });
            $scope.getStatus($scope.BBLE);
        }
        $scope.$broadcast('ownerliens-reload');
        $scope.$broadcast('clearance-reload');
        $scope.$broadcast('titledoc-reload')

        $scope.checkReadOnly(TitleControlReadOnly);
        $scope.$apply();
    };
    $scope.Get = function (isSave) {
        if (isSave) {
            $scope.updateBuyerTitle();
        }
        return $scope.Form;
    }; /* end convention function */

    $scope.checkReadOnly = function (ro) {

        if (ro) {
            $("#TitleUIContent input").attr("disabled", true);
            if ($("#TitleROBanner").length == 0) {
                $("#title_prioity_content").before("<div class='barner-warning text-center' id='TitleROBanner' >Readonly</div>");
            }

        }
    };
    $scope.completeCase = function () {
        if ($scope.CaseStatus != 1 && $scope.BBLE) {
            ptCom.confirm("You are going to complated the case?", "")
                .then(function (r) {
                    if (r) {
                        $http({
                            method: 'POST',
                            url: '/api/Title/Completed',
                            data: JSON.stringify($scope.BBLE)
                        }).then(function success() {
                            $scope.CaseStatus = 1;
                            $scope.Form.FormData.CompletedDate = new Date();
                            ptCom.alert("The case have moved to Completed");
                        }, function error() { });
                    }
                });
        } else if ($scope.BBLE) {
            ptCom.confirm("You are going to uncomplated the case?", "")
                .then(function (r) {
                    if (r) {
                        $http({
                            method: 'POST',
                            url: '/api/Title/UnCompleted',
                            data: JSON.stringify($scope.BBLE)
                        }).then(function success() {
                            $scope.CaseStatus = -1;
                            ptCom.alert("Uncomplete case successful");
                        }, function error() { });
                    }
                });
        }
    };
    $scope.updateCaseStatus = function () {
        if ($scope.CaseStatus && $scope.BBLE) {
            $scope.ChangeStatusIsOpen = false;
            ptCom.confirm("You are going to change case status?", "")
               .then(function (r) {
                   if (r) {
                       $http({
                           method: 'POST',
                           url: '/api/Title/UpdateStatus?bble=' + $scope.BBLE,
                           data: JSON.stringify($scope.CaseStatus)
                       }).then(function success() {
                           ptCom.alert("The case status has changed!");
                       }, function error() { });
                   }
               });
        }
    };
    $scope.getStatus = function (bble) {
        $http.get('/api/Title/GetCaseStatus?bble=' + bble)
        .then(function succ(res) {
            $scope.CaseStatus = res.data;
        }, function error() {
            $scope.CaseStatus = -1;
            console.log("get status error");
        });
    };
    $scope.generateXML = function () {
        $http({
            url: "/api/Title/GenerateExcel",
            method: "POST",
            data: JSON.stringify($scope.Form)
        }).then(function (res) {
            STDownloadFile("/api/Title/GetGeneratedExcel", "titlereport.xlsx");
        });
    };
    $scope.updateBuyerTitle = function () {
        var updateFlag = false;
        var data = $scope.BuyerTitle;
        var newdata = $scope.Form.FormData.info;
        if (data && newdata) {

            if (newdata.Company != data.CompanyName) {
                data.CompanyName = newdata.Company;
                updateFlag = true;
            }

            if (newdata.Title_Num != data.OrderNumber) {
                data.OrderNumber = newdata.Title_Num;
                updateFlag = true;
            }

            if (ptCom.toUTCLocaleDateString(newdata.Order_Date) != ptCom.toUTCLocaleDateString(data.ReportOrderDate)) {
                updateFlag = true;
            }
            data.ReportOrderDate = newdata.Order_Date;

            if (ptCom.toUTCLocaleDateString(newdata.Confirmation_Date) != ptCom.toUTCLocaleDateString(data.ConfirmationDate)) {
                updateFlag = true;
            }
            data.ConfirmationDate = newdata.Confirmation_Date;

            if (ptCom.toUTCLocaleDateString(newdata.Received_Date) != ptCom.toUTCLocaleDateString(data.ReceivedDate)) {
                updateFlag = true;
            }
            data.ReceivedDate = newdata.Received_Date;

            if (ptCom.toUTCLocaleDateString(newdata.Initial_Reivew_Date) != ptCom.toUTCLocaleDateString(data.ReviewedDate)) {
                updateFlag = true;
            }
            data.ReviewedDate = newdata.Initial_Reivew_Date;

            if (updateFlag) {
                $http({
                    url: "/api/ShortSale/UpdateBuyerTitle",
                    method: 'POST',
                    data: JSON.stringify(data)
                }).then(function succ(res) {
                    if (!res) console.log("fail to update buyertitle");
                }
                , function error() {
                    console.log("fail to update buyertitle");
                });
            }
        }
    };
}])
.controller("TitleCommentCtrl", ['$scope', function ($scope) {
    $scope.showPopover = function (e) {
        aspxConstructionCommentsPopover.ShowAtElement(e.target);
    };
    $scope.addComment = function (comment, user) {
        var newComments = {};
        newComments.comment = comment;
        newComments.caseId = $scope.CaseId;
        newComments.createBy = user;
        newComments.createDate = new Date();
        $scope.Form.FormData.Comments.push(newComments);
    };
    $scope.addCommentFromPopup = function (user) {
        var comment = $scope.addCommentTxt;
        $scope.addComment(comment, user);
        $scope.addCommentTxt = '';
    };
    $scope.$on('titleComment', function (e, args) {
        $scope.addComment(args.message);
    }); /* end comments */
}])
.controller('TitleLienCtrl', ['$scope', 'ptCom', '$timeout', function ($scope, ptCom, $timeout) {
    $scope.Form = $scope.$parent.Form;
    $scope.OwnerLienPopup = [false, false];

    $scope.reload = function () {
        $scope.Form = $scope.$parent.Form;
        $scope.OwnerLienPopup = [false, false];
    }

    $scope.setPopVisible = function (model, step, index) {
        $scope.OwnerLienPopup[index] = true;
        model.popStep = step ? step : 0;

    }

    $scope.setPopHide = function (model, index) {
        $scope.OwnerLienPopup[index] = false;
        model.popStep = 0;
    }

    $scope.showWatermark = function (model) {
        var result = true;
        _.each(model, function (n) {
            result &= !n;
        });
        return result;
    }

    $scope.showNext = function (model) {
        var step = model.popStep;
        return ptCom.next(model.shownlist, true, step) >= 0;
    }
    $scope.next = function (model, index) {
        var step = model.popStep;
        if ($scope.showNext(model)) {
            model.popStep = ptCom.next(model.shownlist, true, step) + 1;
        } else {
            $scope.setPopHide(model, index);
        }

    }
    $scope.showPrevious = function (model) {
        var step = model.popStep;
        return ptCom.previous(model.shownlist, true, step) >= 0;
    }

    $scope.previous = function (model, index) {
        var step = model.popStep;
        if ($scope.showPrevious(model)) {
            model.popStep = ptCom.previous(model.shownlist, true, step - 1) + 1;
        } else {
            $scope.setPopHide(model, index);
        }
    }

    $scope.$on('ownerliens-reload', function (e, args) {
        $scope.reload();
    });
    $scope.swapOwnerPos = function (index) {
        $timeout(function () {
            var temp1 = $scope.Form.FormData.Owners[index];
            $scope.Form.FormData.Owners[index] = $scope.Form.FormData.Owners[index - 1];
            $scope.Form.FormData.Owners[index - 1] = temp1;
        });
    };
}])
.controller('TitleFeeClearanceCtrl', ['$scope', function ($scope) {
    var FeeClearanceModel = function () {
        this.data = [
            {
                name: 'Purchase Price',
                cost: 0.0,
                lastupdate: null, note: ''

            },
            {
                name: '2nd Lien',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'Taxes due',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'Water',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'Multi Dwelling',
                cost: 0.0,
                lastupdate: null, note: ''

            },
            {
                name: 'PVB',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'ECBS',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'Judgments',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'Taxes on HUD',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'Water on HUD',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'HPD on HUD',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'ECB on hud',
                cost: 0.0,
                lastupdate: null, note: ''
            }],
        this.total = 0.0

    }

    $scope.FormData = $scope.$parent.Form.FormData;
    $scope.FormData.FeeClearance = new FeeClearanceModel();
    $scope.reload = function () {
        $scope.FormData = $scope.$parent.Form.FormData;
        if ($scope.$parent.Form.FormData.FeeClearance) {
            $scope.FormData.FeeClearance = $scope.FormData.FeeClearance;
        } else {
            $scope.FormData.FeeClearance = new FeeClearanceModel();
        }
    }
    $scope.updateTotal = function (d) {
        d.lastupdate = new Date();
        var total = 0.0;
        _.each($scope.FormData.FeeClearance.data, function (el, idx) {
            total += parseFloat(el.cost) ? parseFloat(el.cost) : 0.0;
        })
        $scope.FormData.FeeClearance.total = total;
    }
    $scope.$on('clearance-reload', function (e, args) {
        $scope.reload();
    })
}])
.controller("TitleDocCtrl", ['$scope', '$http', 'ptCom', function ($scope, $http, ptCom) {
    $scope.transferors = [
        {
            name: 'Ron Borovinsky'
        }, {
            name: 'Jay Gottlieb'
        }, {
            name: 'Princess Simeon'
        }, {
            name: 'Eliezer Herts'
        }, {
            name: 'Magda Brillite'
        }, {
            name: 'Tomer Aronov'
        }, {
            name: 'Moisey Iskhakov'
        }, {
            name: 'Albert Gavriyelov'
        }, {
            name: 'Yvette Guizie'
        }, {
            name: 'Michael Gendin'
        }

    ]
    $scope.data = $scope.$parent.Form.FormData.docs;
    $scope.ReloadedData = {};

    $scope.generatePackage = function () {
        $("#generatedDocsLink").hide()
        $("#generatedDocWarning").hide()
        ptCom.startLoading();

        $http({
            url: "/api/Title/GeneratePakcage",
            method: "POST",
            data: $scope.data
        }).then(function (res) {
            ptCom.stopLoading();
            if (res.data.length > 0) {
                $("#generatedDocsLink").show();
            } else {
                $("#generatedDocWarning").show();
            }
        }, function () {
            ptCom.stopLoading();
            $("#generatedDocWarning").show();
        })
    }

    $scope.$on('titledoc-reload', function (e, args) {
        $scope.data = $scope.$parent.Form.FormData.docs;
        $scope.ReloadedData = {};
    })


}])
angular.module("PortalApp")
    .controller('VendorCtrl', ["$scope", "$http" ,"$element", function ($scope, $http, $element) {

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
            $scope.InitDataFunc(data);
            $scope.AllTest = data.d;

        }).error(function (data, status, headers, config) {
            $scope.LogError = data
            alert("error get contacts: " + status + " error :" + data.d);
        });

    $scope.initLenderList = function () {
        $http.post('/CallBackServices.asmx/GetLenderList', {}).success(function (data, status) {
            $scope.lenderList = _.uniq(data.d);
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
            alert("Add" + $scope.currentContact.Name + " succeed !");
            //debugger;
        }).
        error(function (data, status, headers, config) {
            // called asynchronously if an error occurs
            // or server returns response with an error status.
            var message = data&& data.Message ?data.Message :JSON.stringify(data)

            alert("Add contact error: " + message);
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
            alert("Save succeed!");
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

}]);