angular.module("PortalApp").service('ptFileService', function () {
    
    this.isIE = function (fileName) {
        return fileName.indexOf(':\\') > -1;
    };
    // get filename by path
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
    // replace special character into underscore
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
    // if bbleORoption a string, then use old method, if it's a object, use configuration
    this.uploadFile = function (data, bbleORoptions, rename, folder, type, callback) {
        if (typeof bbleORoptions == 'string') {
            switch (type) {
                case 'construction':
                    this.uploadConstructionFile(data, bbleORoptions, rename, folder, callback);
                    break;
                case 'title':
                    this.uploadTitleFile(data, bbleORoptions, rename, folder, callback);
                    break;
                default:
                    this.uploadConstructionFile(data, bbleORoptions, rename, folder, callback);
                    break;
            }
        } else {
            var options = bbleORoptions;
            var url = options.url || '';
            var filename = options.filename || '';
            var callback = options.callback;
            if (!data || !url || !filename) {
                callback('error');
            }
            $.ajax({
                url: url,
                type: 'POST',
                data: data,
                cache: false,
                processData: false,
                success: function (data) {
                    callback(null, data, filename);
                },
                error: function (data) {
                    callback('fail to upload.', data, filename);
                }

            })
        }
       
    };
    this.uploadTitleFile = function (data, bble, rename, folder, callback) {
        var rename =  rename || '';
        var folder =  folder || '';
        if (!data || !bble) {
            callback('Upload infomation missing!');
        } else {
            bble = bble.trim();
            $.ajax({
                url: '/api/Title/UploadFiles?bble=' + bble + '&fileName=' + rename + '&folder=' + folder,
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
        var rename = rename || '';
        var folder = folder || '';
        if (!data || !bble) {
            callback('Upload infomation missing!');
        } else {
            bble = bble.trim();
            $.ajax({
                url: '/api/ConstructionCases/UploadFiles?bble=' + bble + '&fileName=' + rename + '&folder=' + folder,
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
})