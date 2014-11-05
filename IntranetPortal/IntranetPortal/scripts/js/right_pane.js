$(document).ready(function () {
   
    $("#right-pane-button").mouseenter(function () {
        $("#right-pane-container").css("right", "0");
    });

    $("#right-pane-container").mouseleave(function () {
        $("#right-pane-container").css("right", "-290px");
    })
}
)


