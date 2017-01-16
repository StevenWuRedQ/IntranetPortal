angular.module("PortalApp")
    .directive("ptEditor",
    [
        "$timeout", function($timeout) {
            return {
                templateUrl: "/js/directives/ptEditor.tpl.html",
                require: "ngModel",
                scope: {
                    ptModel: "=ngModel"
                },
                link: function(scope, el, attrs, ctrl) {
                    scope.contentShown = true;
                    scope.editorShown = false;
                    scope.showCK = function() {
                        scope.contentShown = false;
                        scope.editorShown = true;
                    };
                    scope.closeCK = function() {
                        scope.contentShown = true;
                        scope.editorShown = false;
                    };
                    $timeout(function() {
                            var ckdiv = $(el).find("div.ptEditorCK")[0];
                            if (CKEDITOR) {
                                var ck = CKEDITOR.replace(ckdiv,
                                {
                                    allowedContent: true,
                                    height: 400
                                });
                                ck.on("pasteState",
                                    function() {
                                        scope.$apply(function() {
                                            ctrl.$setViewValue(ck.getData());
                                        });
                                    });
                                ctrl.$render = function(value) {
                                    ck.setData(ctrl.$modelValue);
                                };
                                ck.setData(ctrl.$modelValue);
                            }

                        },
                        1000);
                }
            };
        }
    ])