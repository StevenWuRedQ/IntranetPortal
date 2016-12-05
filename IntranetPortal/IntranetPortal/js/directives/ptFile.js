angular.module("PortalApp")
    .directive('ptFile', ['ptFileService', '$timeout', function (ptFileService, $timeout) {
        return {
            restrict: 'E',
            templateUrl: '/js/directives/ptFile.tpl.html',
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
    }])