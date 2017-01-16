/**
 * @param fileModel: the angular model, store url for uploaded file.
 * @param fileBBLE: if provide, will use old style upload. (compatiable with first version)
 *                  if not provide, use configuration to upload file.
 * @param uploadType: come with 
 * @param uploadUrl: webservice url for uploading file. 
 * @param fileName: rename uploaded file at server end. (optional)
 * @param enableEdit: if usercan edit file after upload. (optional)
 * @param enableDelete: if user can delete file after upload. (optional)
 */
angular.module('PortalApp')
    .directive('ptFile', ['ptFileService', '$timeout', 'ptCom',function (ptFileService, $timeout, ptCom) {
        return {
            restrict: 'E',
            templateUrl: '/js/directives/ptFile.tpl.html',
            scope: {
                fileModel: '=',
                fileBble: '=', 
                uploadType: '@',
                uploadUrl: '@',
                fileName: '@', 
                disableDelete: '=?',
                disableModify: '=?',
                ngDisabled: '=?'
            },
            link: function (scope, el, attrs) {
                scope.ptFileService = ptFileService;
                scope.fileId = "ptFile" + scope.$id;
                var mode = 0; // legency mode, bble is require for uploading 
                debugger;
                if (attrs['fileBble'] == undefined) {
                    mode = 1; // new mode, upload based on configuration
                }
                scope.uploadType = scope.uploadType || 'construction';
                scope.ngDisabled = scope.ngDisabled || false;
                scope.disableModify = scope.disableModify || scope.ngDisabled;
                scope.disableDelete = scope.disableDelete || scope.ngDisabled;
                scope.fileChoosed = false;
                scope.loading = false;

                scope.delFile = function () {
                    scope.fileModel = null;
                }
                scope.delChoosed = function () {
                    scope.File = null;
                    scope.fileChoosed = false;
                    var fileEl = el.find('input:file')[0];
                    fileEl.value = '';
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
                    debugger;
                    scope.startLoading();
                    var data = new FormData();
                    data.append("file", scope.File);
                    var filename = ptFileService.getFileName(scope.File.name); 
                    var rename = scope.fileName || '';
                    var callback = function (error, data) {
                        scope.stopLoading();
                        if (error) {
                            ptCom.alert(error);
                        } else {
                            scope.$apply(function () {
                                scope.fileModel = {}
                                scope.fileModel.path = data[0];
                                scope.fileModel.thumb = data[1] || '';
                                scope.fileModel.name = ptFileService.getFileName(scope.fileModel.path);
                                scope.fileModel.uploadTime = new Date();
                                scope.delChoosed();
                            });
                        }

                    } 
                    if (mode == 0) {
                        ptFileService.uploadFile(data, scope.fileBble, filename , rename , scope.uploadType, callback);
                    } else {
                        ptFileService.uploadFile(data, {
                            url: scope.uploadUrl,
                            filename: rename || filename,
                            callback: callback
                        })
                    }
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
                scope.modifyName = function (model) {
                    if (model) {
                        scope.ModifyNamePop = true;
                        scope.NewFileName = model.name ? model.name : '';
                        scope.editingFileModel = model;
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