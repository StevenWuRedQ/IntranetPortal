angular.module("PortalApp")
    .directive('ptFiles', ['$timeout', 'ptFileService', 'ptCom', function ($timeout, ptFileService, ptCom) {
        return {
            restrict: 'E',
            templateUrl: '/js/templates/ptfiles.html',
            scope: {
                fileModel: '=',
                fileBble: '=',
                fileId: '@',
                fileColumns: '@',
                folderEnable: '@',
                baseFolder: '@',
                uploadType: '@' // which folder to upload
            },
            link: function (scope, el, attrs) {
                scope.ptFileService = ptFileService;
                scope.ptCom = ptCom;

                // init scope variale
                scope.files = []; // file to upload
                scope.columns = []; // addtional infomation for files
                scope.nameTable = []; // record choosen files
                scope.currentFolder = '';
                scope.showFolder = false;
                scope.uploadType = scope.uploadType || 'construction';
                scope.loading = false;
                scope.baseFolder = scope.baseFolder ? scope.baseFolder : '';
                scope.count = 0; // count for uploaded files


                if (scope.fileColumns) {
                    scope.columns = scope.fileColumns.split('|');
                    _.each(scope.columns, function (elm) {
                        elm.trim();
                    });
                }

                scope.folders = _.without(_.uniq(_.pluck(scope.fileModel, 'folder')), undefined, '')

                scope.$watch('fileModel', function () {
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

                scope.OnDropTextarea = function (event) {
                    if (event.originalEvent.dataTransfer) {
                        var files = event.originalEvent.dataTransfer.files;
                        scope.addFiles(files);
                    } else {
                        alert("Your browser does not support the drag files.");
                    }
                }

                // utility functions
                scope.changeFolder = function (folderName) {
                    scope.currentFolder = folderName;
                    scope.showFolder = true;
                }
                scope.addFolder = function (folderName) {
                    if (scope.folders.indexOf(folderName) < 0) {
                        scope.folders.push(folderName);
                    }
                    scope.currentFolder = folderName;
                    scope.showFolder = true;
                }
                scope.hideFolder = function () {
                    scope.currentFolder = "";
                    scope.showFolder = false;
                }
                scope.toggleNewFilePop = function () {
                    scope.NewFolderPop = !scope.NewFolderPop
                    scope.NewFolderName = '';
                }
                scope.newFolderPopSave = function () {
                    scope.addFolder(scope.NewFolderName);
                    scope.NewFolderPop = false;
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
                    var error = _.some(scope.result, function (el) {
                        return el.error
                    });
                    return !scope.uploading && error;
                }


                scope.uploadFile = function () {

                    var targetFolder = (scope.baseFolder ? scope.baseFolder + '/' : '') + (scope.currentFolder ? scope.currentFolder + '/' : '')
                    var len = scope.files.length;

                    scope.fileModel = scope.fileModel ? scope.fileModel : [];
                    scope.result = []; // final result will store here, but we build up it first for counting

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

                    for (var j = 0; j < len; j++) {
                        var data = new FormData();
                        data.append("file", scope.files[j]);
                        var targetName = ptFileService.getFileName(scope.files[j].name);
                        ptFileService.uploadFile(data, scope.fileBble, targetName, targetFolder, scope.uploadType, function callback(error, data, targetName) {
                            var targetElement;
                            if (error) {
                                scope.countCallback(len);
                                targetElement = _.filter(scope.result, function (el) {
                                    return el.name == targetName
                                })[0];
                                if (targetElement) {
                                    targetElement.error = error;
                                }

                            } else {
                                scope.countCallback(len);
                                targetElement = _.filter(scope.result, function (el) {
                                    return el.name == targetName
                                })[0];
                                if (targetElement) {
                                    targetElement.path = data[0];
                                    if (data[1]) {
                                        targetElement.thumb = data[1];
                                    }
                                }
                                scope.fileModel.push(targetElement);
                            }
                        });
                    }

                }

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

                scope.filterError = function (v) {
                    return v.error;
                }

            }

        }

    }])