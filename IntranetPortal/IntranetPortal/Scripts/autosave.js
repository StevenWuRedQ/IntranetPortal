/* code area steven*/
$.wait = function (ms) {
    var defer = $.Deferred();
    setTimeout(function () { defer.resolve(); }, ms);
    return defer;
};

function CheckDateSpan(startTime, endTime) {
    var dif = endTime.getTime() - startTime.getTime();
    return dif / 1000;
}

function NGAddArrayitemScope(scopeId, model) {
    var $scope = angular.element(document.getElementById(scopeId)).scope();
    if (model) {
        var array = $scope.$eval(model);
        if (!array) {
            $scope.$eval(model + '=[{}]');
        } else {

            $scope.$eval(model + '.push({})');
            //test
        }
        $scope.$apply();
    }
}

function ScopeCaseDataChanged(getDataFunc) {
    if ($('#CaseData').length === 0) {
        alert("can not find input case data elment");
        $('<input type="hidden" id="CaseData" />').appendTo(document.body);
        return false;
    }
    //var dateNow = new Date();
    var isChanged = $('#CaseData').val() != "" && $('#CaseData').val() != JSON.stringify(getDataFunc());
    return isChanged
}

function ScopeResetCaseDataChange(getDataFunc) {
    var caseData = getDataFunc();
    if ($('#CaseData').length === 0) {
        $('<input type="hidden" id="CaseData" />').appendTo(document.body);    }
    $('#CaseData').val(JSON.stringify(caseData));
}

function ScopeAutoSave(getDataFunc, SaveFunc, headEelem) {
    if ($(headEelem).length <= 0) {
        return;
    }
    if (typeof GetDataReadOnly !== 'undefined' && !GetDataReadOnly()) {
        return;
    }
    // delay the first run after 30 second!
    $.wait(5000).then(function () {
        window.setInterval(function () {
            if (ScopeCaseDataChanged(getDataFunc)) {
                SaveFunc();
            }
        }, 5000);
    });
}

function ScopeSetLastUpdateTime(url, date) {
    if (url) {
        $.getJSON(url, function (data) {
            $('#LastUpdateTime').val(JSON.stringify(data));
        });
    }
    if (date) {
        $('#LastUpdateTime').val(date);
    }

}

function CheckLastUpdateChangedByOther(urlFunc, reLoadUIfunc, loadUIIdFunc, urlModfiyUserFunc) {
    var url = urlFunc();
    $.getJSON(url, function (data) {
        var lastUpdateTime = JSON.stringify(data);
        var localUpdateTime = $('#LastUpdateTime').val();
        if (localUpdateTime && localUpdateTime !== lastUpdateTime) {
            if (urlModfiyUserFunc) {
                $.getJSON(urlModfiyUserFunc(), function (mUser) {
                    if (mUser) {
                        if (mUser !== "sameuser") {
                            alert(mUser + " has changed your file at " + lastUpdateTime + ". Our system will load the latest data, and the data you just input may miss.");
                        }
                        reLoadUIfunc(loadUIIdFunc());
                        ScopeSetLastUpdateTime(null, lastUpdateTime);
                    }

                });
            } else {
                alert("Someone has changed your file at " + lastUpdateTime + ". Our system will load the latest data, and the data you just input may miss.");
                reLoadUIfunc(loadUIIdFunc());
            }
        }
    });
}

function ScopeDateChangedByOther(urlFunc, reLoadUIfunc, loadUIIdFunc, urlModfiyUserFunc) {
    window.setInterval(function () {
        CheckLastUpdateChangedByOther(urlFunc, reLoadUIfunc, loadUIIdFunc, urlModfiyUserFunc);
    }, 10000);

}