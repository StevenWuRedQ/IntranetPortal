angular.module("PortalApp")
    .factory('ptLegalService', function () {
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
    })