$(document).ready(function () {
   
    $("#right-pane-button").mouseenter(function () {
        $("#right-pane-container").css("right", "0");
    });

    $('body').click(function (e) {
        if (e.target.id == 'right-pane-container')
        { return true;}
        else
        {
           $("#right-pane-container").css("right", "-290px");
        }

    });
    //$("#right-pane-container").mouseleave(function () {
    //    $("#right-pane-container").css("right", "-290px");
    //})
}
)


