var portalApp = angular.module('PortalApp');

portalApp.directive('ssDate', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {
            $(el).datepicker();
            var initFlag = true;
            scope.$watch(attrs.ngModel, function (newValue, oldValue) {
                var dateStr = newValue;
                if (!dateStr && oldValue != null && initFlag) {
                    scope.$eval(attrs.ngModel + "='" + oldValue + "'");
                    initFlag = false;
                }
                dateStr = !dateStr ? null : dateStr.toString();
                if (dateStr && dateStr.indexOf('-') >= 0) {
                    var dd = new Date(dateStr);
                    dd = (dd.getUTCMonth() + 1) + '/' + (dd.getUTCDate()) + '/' + dd.getUTCFullYear();
                    scope.$eval(attrs.ngModel + "='" + dd + "'");
                }
            });
        }
    };
});

portalApp.directive('inputMask', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {
            $(el).mask(attrs.inputMask);
            $(el).on('change', function () {
                scope.$eval(attrs.ngModel + "='" + el.val() + "'");
            });
        }
    };
});

portalApp.directive('bindId', function (ptContactServices) {
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
});

portalApp.directive('ptInitModel', function () {
    return {
        restrict: 'A',
        require: '?ngModel',
        link: function (scope, el, attrs) {
            scope.$watch(attrs.ptInitModel, function (newVal) {
                if (!scope.$eval(attrs.ngModel) && newVal) {
                    if (typeof newVal == 'string') newVal = newVal.replace(/'/g, "\\'");
                    scope.$eval(attrs.ngModel + "='" + newVal + "'");
                }
            });
        }
    }
});

//one way bind of ptInitModel
portalApp.directive('ptInitBind', function () {
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
});

portalApp.directive('radioInit', function () {
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
});

portalApp.directive('moneyMask', function () {
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
});

portalApp.directive('numberMask', function () {
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
});

portalApp.directive('percentMask', function () {
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
});

portalApp.directive('ptRadio', function () {
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
});

portalApp.directive('ptCollapse', function () {
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
});

portalApp.directive('ckEditor', [function () {
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
}]);

portalApp.directive('ptAdd', function () {
    return {
        restrict: 'E',
        template: '<i class="fa fa-plus-circle icon_btn text-primary tooltip-examples" title="Add"></i>',
    }
});

portalApp.directive('ptDel', function () {
    return {
        restrict: 'E',
        template: '<i class="fa fa-times icon_btn text-danger tooltip-examples" title="Delete"></i>',
    }
});

portalApp.directive('ptFile', ['ptFileService', '$timeout', function (ptFileService, $timeout) {
    return {
        restrict: 'E',
        templateUrl: '/Scripts/templates/ptfile.html',
        scope: {
            fileModel: '=',
            fileBble: '=',
            fileName: '@',
            fileId: '@'
        },
        link: function (scope, el, attrs) {
            scope.ptFileService = ptFileService;
            scope.fileChoosed = false;
            scope.loading = false;
            scope.delFile = function () {
                scope.fileModel = '';
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
                ptFileService.uploadConstructionFile(data, scope.fileBble, scope.fileName, '', function (error, data) {
                    scope.stopLoading();
                    if (error) {
                        alert(error);
                    } else {
                        scope.$apply(function () {
                            scope.fileModel = data[0];
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
        }
    }
}]);

portalApp.directive('ptFiles', ['$timeout', 'ptFileService', 'ptCom', function ($timeout, ptFileService, ptCom) {
    return {
        restrict: 'E',
        templateUrl: '/Scripts/templates/ptfiles.html',
        scope: {
            fileModel: '=',
            fileBble: '=',
            fileName: '@',
            fileId: '@',
            fileColumns: '@',
            fileFolder: '@',
            onFileProcess: '&',
            onFileDone: '&'
        },
        link: function (scope, el, attrs) {
            scope.ptFileService = ptFileService;
            scope.ptCom = ptCom;


            // init scope variale
            scope.files = [];
            scope.columns = [];
            scope.nameTable = [];   // record choosen files
            scope.currentFolder = '';

            scope.loading = false;
            scope.folderEnable = scope.fileFolder == 'true' ? true : false;


            if (scope.fileColumns) {
                scope.columns = scope.fileColumns.split('|');
                _.each(scope.columns, function (elm) {
                    elm.trim();
                });
            }
            scope.folders = _.without(_.uniq(_.pluck(scope.fileModel, 'folder')), undefined)

            // reg events            
            scope.$watch(function () {
                return scope.fileModel.$modelValue;
            }, function () {
                scope.currentFolder = '';
                scope.folders = _.without(_.uniq(_.pluck(scope.fileModel, 'folder')),undefined)
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
            scope.changeFolder = function (folder) {
                scope.currentFolder = folder;
            }
            scope.addFolder = function (folderName) {
                scope.folders.push(folderName);
                scope.currentFolder = folderName;
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
                scope.startLoading();
                var data = new FormData();
                for (var i = 0; i < scope.files.length; i++) {
                    data.append("file", scope.files[i]);
                }
                ptFileService.uploadConstructionFile(data, scope.fileBble, scope.fileName, scope.currentFolder, function (error, data) {
                    scope.stopLoading();
                    if (error) {
                        alert(error);
                    } else {
                        scope.$apply(function () {
                            scope.fileModel = scope.fileModel ? scope.fileModel : [];
                            for (var i = 0; i < data.length; i++) {
                                var newCol = {};
                                newCol.path = data[i];
                                newCol.name = ptFileService.getFileName(newCol.path);
                                newCol.folder = ptFileService.getFileFolder(newCol.path);
                                newCol.uploadTime = new Date();                                
                                for (var j = 0; j < scope.columns.length; j++) {
                                    var column = scope.columns[j];
                                    newCol[column] = '';
                                }
                                scope.fileModel.push(newCol);
                            }
                            scope.clearChoosed();
                        });
                    }

                });
            }



        }

    }

}]);

portalApp.directive('ptComments', ['ptCom', function (ptCom) {

    return {
        restrict: 'E',
        scope: {
            commentsModel: '=',
            createBy: '@',

        },
        templateUrl: '/Scripts/templates/comments_panel.html',
        link: function (scope, el, attrs) {
            scope.ptCom = ptCom;
            scope.addComment = function () {
                scope.$apply(function () {
                    scope.commentsModel = scope.commentsModel ? scope.commentsModel : [];
                    var newComment = {};
                    newComment.comment = scope.inputText;
                    newComment.createBy = scope.createBy;
                    newComment.createDate = new Date();
                    scope.commentsModel.push(newComment);
                    scope.inputText = '';
                });
            }

        }
    }

}])