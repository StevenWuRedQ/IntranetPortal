angular.module("PortalApp")
    .directive('ptRequired', function () {
        return {
            restrict: 'A',
            link: function (scope, el, attrs) {
                // debugger;
                var eltype = $(el)[0].type;

                if (eltype != 'text' && eltype != 'textarea' && eltype != 'select-one') {
                    return;
                }


                var validate = function (v) {
                    if (eltype == 'text' || eltype == 'textarea') {
                        if (v && typeof v == 'string' && v.trim().length > 0) {
                            return true;
                        } else {
                            return false
                        }
                    } else if (eltype == 'select-one') {
                        return v == undefined || (typeof v == 'string' && (v.trim().length == 0 || v.indexOf('?') == 0)) ? false : true;
                    } else {
                        return false;
                    }
                }

                var callback = function () {
                    debugger
                    var res = validate($(el)[0].value);
                    if (!res) {
                        $(el).css("background-color", "yellow");
                        $(el).attr('error', 'true');
                        if ($(el)[0].type == 'text' || $(el)[0].type == 'textarea') {
                            $(el)[0].placeholder = 'content is required.'
                        }

                    } else {
                        $(el).css("background-color", "");
                        $(el).attr('error', '');
                        if ($(el)[0].type == 'text' || $(el)[0].type == 'textarea') {
                            $(el)[0].placeholder = ''
                        }
                    }
                }

                $(el).on('blur', callback);
                scope.$on('ptSelfCheck', callback);

            },
        };
    })