$(function () {
    window.autoLogout_lastCheck = new Date();
    // recheck every 30 minutes
    var CHECK_INTERVAL = 1000 * 60 * 60 * 30;
    // after 30 second logout
    var CONFRIM_INTERVAL = 1000 * 30;
    var autoLogoutPopup_visible = false;
    $("#autoLogoutPopup").dxPopup({
        width: 600,
        height: 200,
        showTitle: false,
        visible: autoLogoutPopup_visible,
        dragEnabled: false,
        closeOnOutsideClick: false
    });

    function checkOnline() {
        $.get("/api/UserInfo/IsActive")
        .done(function (data, status, jqxhr) {
            if (data == false) {
                $("#autoLogoutPopup").dxPopup("instance").show();
                var countDown = 29;
                var logoutCountDown = function () {
                    if (countDown > 0) {
                        countDown--;
                        $("#autoLogoutCountDown").html(countDown);
                    } else {
                        clearInterval(logoutCountDown);
                    }
                }
                setInterval(logoutCountDown, 1000);

                window.setTimeout(function () {
                    if ($("#autoLogoutPopup").dxPopup("instance").option("visible") === true) {
                        window.onAutoLogout();
                    }
                }, CONFRIM_INTERVAL);
            }

        })
        .fail(function (data, status, error) {
            window.onAutoLogout();
        })
    }

    window.onAutoLogoutPopupYes = function () {
        $("#autoLogoutPopup").dxPopup("instance").hide();
        $.get("/api/UserInfo/UpdateRefreshTime")
            .done(function () {
                window.autoLogout_lastCheck = new Date();
            })


    }

    window.onAutoLogout = function () {
        $("#autoLogoutPopup").dxPopup("instance").hide();
        window.location.href = "/Account/Logout.aspx";
    }

    setInterval(checkOnline, CHECK_INTERVAL);

});