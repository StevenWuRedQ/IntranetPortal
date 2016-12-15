angular.module("PortalApp")
    .directive('ptEditor', [function () {
        return {

            templateUrl: '/js/directives/ptEditor.html',
            require: 'ngModel',
            scope: {
                ptModel: '=ngModel'
            },
            link: function (scope, el, attrs, ctrl) {
                scope.contentShown = true;
                var ckdiv = $(el).find("div.ptEditorCK")[0];
                var ck = CKEDITOR.replace(ckdiv, {
                    allowedContent: true,
                    height: 400,
                });
                scope.editorShown = false;

                scope.showCK = function () {
                    scope.contentShown = false;
                    scope.editorShown = true;
                }
                scope.closeCK = function () {
                    scope.contentShown = true;
                    scope.editorShown = false;
                }

                ck.on('pasteState', function () {
                    scope.$apply(function () {
                        ctrl.$setViewValue(ck.getData());
                    });
                });

                ctrl.$render = function (value) {
                    ck.setData(ctrl.$modelValue);
                };

                ck.setData(ctrl.$modelValue);
            }
        };
    }])