angular.module("PortalApp").service("ptCom", ["$http", "$rootScope", function ($http, $rootScope) {
    var that = this;

    this.DocGenerator = function (tplName, data, successFunc) {
        $http.post("/Services/Documents.svc/DocGenrate", { "tplName": tplName, "data": JSON.stringify(data) }).success(function (data) {
            successFunc(data);
        }).error(function (data, status) {
            alert("Fail to save data. status: " + status + " Error : " + JSON.stringify(data));
        });
    }; 

    this.arrayAdd = function (model, data) {
        if (model) {
            data = data ? data : {};
            model.push(data);
        }
    };
    this.arrayRemove = function (model, index, confirm, callback) {
        if (model && index < model.length) {
            if (confirm) {
                that.confirm("Delete This?", "").then(function (r) {
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
        popupWin.document.write('<html><head>'+
        '<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" />'+
        '<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" />'+
        '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/3.0.3/normalize.min.css" />'+
        '<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />'+
        '<link rel="stylesheet" href="/Content/bootstrap-datepicker3.css" />'+
        '<link rel="stylesheet" href="http://cdn3.devexpress.com/jslib/15.1.6/css/dx.common.css" />'+
        '<link rel="stylesheet" href="http://cdn3.devexpress.com/jslib/15.1.6/css/dx.light.css" />'+
        '<link rel="stylesheet" href="/css/stevencss.css"type="text/css" />'+
        '</head><body onload="window.print()">' + divToPrint.innerHTML + '</html>');
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
}]).service('ptFileService', function () {
    
    this.isIE = function (fileName) {
        return fileName.indexOf(':\\') > -1;
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

    this.getThumb = function (thumbId) {
        return '/downloadfile.aspx?thumb=' + thumbId;

    };
    this.trunc = function (fileName, length) {
        return _.trunc(fileName, length);

    };
    
    this.isPicture = function (fullPath) {
        var ext = this.getFileExt(fullPath);
        var pictureExts = ['jpg', 'jpeg', 'gif', 'bmp', 'png'];
        return pictureExts.indexOf(ext) > -1;
    };

    
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
        folder = folder ? folder : '';
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

}).service('ptConstructionService', ['$http', function ($http) {
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
]).service("ptTime", [function () {
    var that = this;

    this.isPassByDays = function (start, end, count) {
        var start_date = new Date(start);
        var end_date = new Date(end);

        // Do the math.
        var millisecondsPerDay = 1000 * 60 * 60 * 24;
        var millisBetween = end_date.getTime() - start_date.getTime();
        var days = millisBetween / millisecondsPerDay;

        if (days > count) {
            return true;
        }

        return false;
    }
    this.isPassOrEqualByDays = function (start, end, count) {
        var start_date = new Date(start);
        var end_date = new Date(end);

        // Do the math.
        var millisecondsPerDay = 1000 * 60 * 60 * 24;
        var millisBetween = end_date.getTime() - start_date.getTime();
        var days = millisBetween / millisecondsPerDay;

        if (days >= count) {
            return true;
        }

        return false;
    }
    this.isLessOrEqualByDays = function (start, end, count) {
        var start_date = new Date(start);
        var end_date = new Date(end);

        // Do the math.
        var millisecondsPerDay = 1000 * 60 * 60 * 24;
        var millisBetween = end_date.getTime() - start_date.getTime();
        var days = millisBetween / millisecondsPerDay;

        if (days >= 0 && days <= count) {
            return true;
        }

        return false;
    }
    this.isPassByMonths = function (start, end, count) {
        var start_date = new Date(start);
        var end_date = new Date(end);
        var months = (end_date.getFullYear() - start_date.getFullYear()) * 12 + end_date.getMonth() - start_date.getMonth();

        if (months > count) return true;
        else return false;
    }
    this.isPassOrEqualByMonths = function (start, end, count) {
        var start_date = new Date(start);
        var end_date = new Date(end);
        var months = (end_date.getFullYear() - start_date.getFullYear()) * 12 + end_date.getMonth() - start_date.getMonth();

        if (months >= count) return true;
        else return false;
    }

}]).service('ptContactServices', ['$http', 'limitToFilter', function ($http, limitToFilter) {

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
    this.getContactsByGroup = function (groupId) {
        if (allContact) return allContact.filter(function (x) { return x.GroupId == groupId });
    };
    
    
    this.getContact = function (id, name) {
        if (allContact) return allContact.filter(function (o) { if (o.Name && name) return o.ContactId == id && o.Name.trim().toLowerCase() === name.trim().toLowerCase() })[0] || {};
        return {};
    };
    this.getContactById = function (id) {
        if (allContact) return allContact.filter(function (o) { return o.ContactId == id; })[0];
        return null;
    };

    this.getContactByName = function (name) {
        if (allContact) return allContact.filter(function (o) { if (o.Name && name) return o.Name.trim().toLowerCase() === name.trim().toLowerCase() })[0];
        return {};
    };
    
    
    this.getEntities = function (name, status) {
        status = status === undefined ? 'Available' : status;
        name = name ? '' : name;
        return $http.get('/Services/ContactService.svc/GetCorpEntityByStatus?n=' + name + '&s=' + status)
            .then(function (res) {
                return limitToFilter(res.data, 10);
            });
    };
    
    this.getTeamByName = function (teamName) {
        if (allTeam) {
            return allTeam.filter(function (o) { if (o.Name && teamName) return o.Name.trim() == teamName.trim() })[0];
        }
        return {};

    };
}]).service('ptShortsSaleService', ['$http', function ($http) {
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
}]).service('ptLeadsService', ["$http", function ($http) {
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
]).factory('ptHomeBreakDownService', ["$http", function ($http) {
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
]).factory('ptLegalService', function () {
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
}).factory('ptEntityService', ['$http', function ($http) {
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