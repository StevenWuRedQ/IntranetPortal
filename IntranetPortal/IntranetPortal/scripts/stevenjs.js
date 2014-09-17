function clickCollapse(e, id) {
    var buttonClassName = e.className;
    var openClass = "-minus";
    var clossClass = "-plus";

    var isOpen = buttonClassName.indexOf(openClass) > 0;
    var toSwich = !isOpen;
    var changeToClass = isOpen ? buttonClassName.replace(openClass, clossClass) : buttonClassName.replace(clossClass, openClass);
    e.className = changeToClass;

    $("#" + id).css("display", toSwich ? "initial" : "none");

}

function swich_edit_model(s, e) {
    var inputs = $(".ss_form_input");
    inputs.addClass("color_blue_edit");
    var checks = $(".input_with_check");
    if (s.GetText() == "Edit") {
        inputs.addClass("color_blue_edit");
        checks.addClass("color_blue_edit");
        s.SetText("Save");
    } else {
        inputs.removeClass("color_blue_edit");
        checks.removeClass("color_blue_edit");
        s.SetText("Edit");
    }


}

$(document).ready(function () {

    if ($(".tooltip-examples").tooltip) {
        $(".tooltip-examples").tooltip({
            placement: 'bottom'
        });
    } else {
        alert('tooltip function can not found' + $(".tooltip-examples").tooltip);
    }
});